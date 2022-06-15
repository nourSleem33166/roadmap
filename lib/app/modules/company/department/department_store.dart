import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/company/company_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/models/department.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/toasts/messages_toasts.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

part 'department_store.g.dart';

class DeptStore = DeptStoreBase with _$DeptStore;

abstract class DeptStoreBase with Store {
  CompanyRepo _companyRepo;

  List<RoadmapModel>? roadmaps = [];
  CompanyModel? company;
  Department? department;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  @observable
  int selectedViewIndex = 0;

  String deptId = "";
  String companyId = "";

  DeptStoreBase(this._companyRepo, String deptId, String companyId) {
    this.deptId = deptId;
    this.companyId = companyId;
    getData();
  }

  void goToRoadmapDetails(RoadmapModel roadmap){
    log("roadmap is ${roadmap.id}");
    Modular.to.pushNamed('/home/roadmapDetails/', arguments: [roadmap.id]);
  }

  @action
  void changeIndex(int index) {
    selectedViewIndex = index;
  }

  @action
  Future<void> getData() async {
    try {
      pageState = ComponentState.FETCHING_DATA;
      await Future.wait([
        _companyRepo.getCompanyById(companyId),
        _companyRepo.getDeptById(deptId, companyId),
        _companyRepo.getDeptRoadmaps(deptId, companyId)
      ]).then((value) {
        company = value[0] as CompanyModel?;
        department = value[1] as Department?;
        roadmaps = value[2] as List<RoadmapModel>?;
        pageState = ComponentState.SHOW_DATA;
      });
    } on AppException catch (e) {
      pageState = ComponentState.ERROR;
      showErrorToast(e.message);
    }
  }
}
