import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/company/company_repo.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/models/department.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/services/pdf_service.dart';
import 'package:roadmap/app/shared/toasts/loading_toast.dart';
import 'package:roadmap/app/shared/toasts/messages_toasts.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

part 'roadmap_store.g.dart';

class RoadmapStore = RoadmapStoreBase with _$RoadmapStore;

abstract class RoadmapStoreBase with Store {
  RoadmapRepo _roadmapRepo;
  CompanyRepo _companyRepo;

  CompanyModel? company;
  RoadmapModel? roadmap;
  Department? department;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  String roadmapId = "";

  RoadmapStoreBase(this._roadmapRepo, this._companyRepo, String roadmapId) {
    this.roadmapId = roadmapId;
    getData();
  }

  @action
  Future<void> getData() async {
    try {
      pageState = ComponentState.FETCHING_DATA;
      roadmap = await _roadmapRepo.getRoadmapById(roadmapId);
      await Future.wait([
        _companyRepo.getCompanyById(roadmap!.companyId),
        _companyRepo.getDeptById(roadmap!.departmentId, roadmap!.companyId)
      ]).then((value) {
        company = value[0] as CompanyModel?;
        department = value[1] as Department;
        pageState = ComponentState.SHOW_DATA;
      });
    } on AppException catch (e) {
      pageState = ComponentState.ERROR;
      showErrorToast(e.message);
    }
  }

  void goToRoadmapGraph() {
    Modular.to.pushNamed('/home/roadmapDetails/roadmapGraph/', arguments: [roadmapId, false]);
  }

  void startLearningRoadmapGraph() async {
    final res = await navigateToScheduler();
    log("res is $res");
    if (res == true) {
      _roadmapRepo.startLearnRoadmap(roadmapId).then((value) async {
        await getData();
        continueLearning();
      });
    }
  }

  void continueLearning() {
    Modular.to.pushNamed('/home/roadmapDetails/roadmapGraph/', arguments: [roadmapId, true]);
  }

  Future<bool?> navigateToScheduler() async {
    final res = await Modular.to
        .pushNamed('/home/profile/scheduler/', arguments: [roadmapId], forRoot: true);
    return res as bool?;
  }

  Future getCertificate() async {
    showLoading();
    final url = await _roadmapRepo.getCertificate(roadmapId);
    if (url == null) {
      showToast('No Certificate Available');
      return;
    }
    final file = await loadPdfFromNetwork(url);
    closeLoading();
    Modular.to
        .pushNamed('/home/roadmapDetails/cert/', arguments: [file, url, roadmap!.title]);
  }
}
