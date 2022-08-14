import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/company/company_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/models/department.dart';
import 'package:roadmap/app/shared/repos/follow_process_repo.dart';
import 'package:roadmap/app/shared/toasts/messages_toasts.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../shared/toasts/shared_report_dialog.dart';

part 'company_store.g.dart';

class CompanyStore = CompanyStoreBase with _$CompanyStore;

abstract class CompanyStoreBase with Store {
  CompanyRepo _companyRepo;
  FollowProcessRepo _followProcessRepo;

  List<Department> departments = [];
  CompanyModel? company;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  String companyId = "";

  @observable
  int selectedViewIndex = 0;

  CompanyStoreBase(this._companyRepo, this._followProcessRepo, String companyId) {
    this.companyId = companyId;
    getData(companyId);
  }

  @action
  void changeIndex(int index) {
    selectedViewIndex = index;
  }

  void goToDeptDetails(Department dept) {
    Modular.to.pushNamed('/home/companyDetails/deptDetails', arguments: [dept.id, companyId]);
  }

  Future followCompany() async {
    runInAction(() {
      company!.isFollowed!.value = true;
    });
    final res = await _followProcessRepo.followCompany(company!.id);
    if (!res) {
      company!.isFollowed!.value = false;
    }
  }

  Future unFollowCompany() async {
    runInAction(() {
      company!.isFollowed!.value = false;
    });
    final res = await _followProcessRepo.unFollowCompany(company!.id);
    if (!res) {
      company!.isFollowed!.value = true;
    }
  }

  Future addCompanyToFavs() async {
    runInAction(() {
      company!.isFavorite!.value = true;
    });
    final res = await _followProcessRepo.addCompanyToFavs(company!.id);
    if (!res) {
      company!.isFavorite!.value = false;
    }
  }

  Future removeCompanyFromFavs() async {
    runInAction(() {
      company!.isFavorite!.value = false;
    });
    final res = await _followProcessRepo.removeCompanyFromFavs(company!.id);
    if (!res) {
      company!.isFavorite!.value = true;
    }
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

  Future reportCompany(BuildContext context, String companyId) async {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height * 0.5,
                child: SumbitMessageDialog()),
          );
        }).then((value) {
      if (value != null) {
        _companyRepo.reportCompany(companyId, value.toString()).then((value) {
          if (value) {
            showSuccessToast('Your Report has been sent');
          }
        });
      }
    });
  }
}
