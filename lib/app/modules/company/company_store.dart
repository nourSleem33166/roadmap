import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/company/company_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/models/department.dart';
import 'package:roadmap/app/shared/toasts/messages_toasts.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

part 'company_store.g.dart';

class CompanyStore = CompanyStoreBase with _$CompanyStore;

abstract class CompanyStoreBase with Store {
  CompanyRepo _companyRepo;

  List<Department> departments = [];
  CompanyModel? company;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  String companyId = "";

  @observable
  int selectedViewIndex = 0;

  CompanyStoreBase(this._companyRepo, String companyId) {
    this.companyId = companyId;
    getData(companyId);
  }

  @action
  void changeIndex(int index) {
    selectedViewIndex = index;
  }

  void goToDeptDetails(Department dept) {
    Modular.to.pushNamed('/home/companyDetails/deptDetails',
        arguments: [dept.id, companyId]);
  }

  @action
  Future<void> getData(String companyId) async {
    try {
      pageState = ComponentState.FETCHING_DATA;
      Future.wait([
        _companyRepo.getCompanyById(companyId),
        _companyRepo.getCompanyDepts(companyId)
      ]).then((value) {
        company = value[0] as CompanyModel?;
        departments = value[1] as List<Department>;
        pageState = ComponentState.SHOW_DATA;
      });
    } on AppException catch (e) {
      pageState = ComponentState.ERROR;
      showErrorToast(e.message);
    }
  }
}
