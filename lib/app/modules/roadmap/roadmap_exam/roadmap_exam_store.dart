import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/exam.dart';
import 'package:roadmap/app/shared/toasts/messages_toasts.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

part 'roadmap_exam_store.g.dart';

class ExamStore = ExamStoreBase with _$ExamStore;

abstract class ExamStoreBase with Store {
  RoadmapRepo _roadmapRepo;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  PageController controller = PageController();

  late Exam exam;

  ExamStoreBase(this._roadmapRepo, this.exam) {
    getData();
  }

  @action
  Future<void> getData() async {
    try {
      pageState = ComponentState.FETCHING_DATA;
    } on AppException catch (e) {
      pageState = ComponentState.ERROR;
      showErrorToast(e.message);
    }
  }

  selectOption(Option option, Question question) {
    if (question.type == 'multiChoice') {
      runInAction(() {
        option.isCorrect.value = !option.isCorrect.value;
      });
    } else {
      question.options.forEach((element) {
        if (element == option) {
          runInAction(() {
            element.isCorrect.value = !option.isCorrect.value;
          });
        } else {
          runInAction(() {
            element.isCorrect.value = false;
          });
        }
      });
    }
  }

  void goToRoadmapGraph() {
    Modular.to.pushNamed('/home/roadmapDetails/roadmapGraph/',
        arguments: [exam.exam.roadmapId, false]);
  }

  void startLearningRoadmapGraph() async {
    navigateToScheduler().then((value) {
      if (value == true) {
        _roadmapRepo.startLearnRoadmap(exam.exam.roadmapId);
      }
    });
  }

  void continueLearning() {
    Modular.to.pushNamed('/home/roadmapDetails/roadmapGraph/',
        arguments: [exam.exam.roadmapId, true]);
  }

  Future navigateToScheduler() async {
    await Modular.to.pushNamed('/home/scheduler/', arguments: [exam.exam.roadmapId]);
  }

  Map examResult = {};

  Future submitLevel(Level level) async {
    examResult = await _roadmapRepo.submitExamLevel(
        exam.exam.roadmapId, exam.exam.id, level.id, level.questions);
    runInAction(() {
      level.isPassed.value = true;
    });
  }
}
