import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_exam/exam_expired_dialog.dart';
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

  ScrollController scrollController = ScrollController();

  late Exam exam;
  Timer? timer;

  ExamStoreBase(this._roadmapRepo, this.exam) {
    getData();
  }

  Timer initTimer(BuildContext context) {
    return Timer(exam.exam.expiredAt.toLocal().difference(DateTime.now()), () {
      showDialog(
          context: context,
          useRootNavigator: false,
          builder: (context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ExamExpiredPage()),
              )).then((value) {
        Modular.to.pop(true);
      });
    });
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
    if (question.type == 'multipleChoice') {
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
    await Modular.to.pushNamed('/home/profile/scheduler/', arguments: [exam.exam.roadmapId]);
  }

  Map levelResult = {};

  Future submitLevel(Level level) async {
    levelResult = await _roadmapRepo.submitExamLevel(
        exam.exam.roadmapId, exam.exam.id, level.id, level.questions);
    if (levelResult['examPassed'] != null) {
      timer?.cancel();
    }

    if (levelResult['levelPassed'] == false) {
      Modular.to.pop(false);
      return;
    }
    runInAction(() {
      level.isPassed.value = true;
    });
    scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}
