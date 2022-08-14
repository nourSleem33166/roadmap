import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/profile/profile_repo.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

part 'followed_companies_store.g.dart';

class FollowedCompaniesStore = FollowedCompaniesStoreBase with _$FollowedCompaniesStore;

abstract class FollowedCompaniesStoreBase with Store {
  ProfileRepo _repo;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  FollowedCompaniesStoreBase(this._repo) {
    initValues();
  }

  List<CompanyModel> followedCompanies = [];

  @action
  Future initValues() async {
    pageState = ComponentState.FETCHING_DATA;
    followedCompanies = await _repo.getFollowedCompanies();
    pageState = ComponentState.SHOW_DATA;
  }
  void goToCompanyDepts(CompanyModel company) {
    Modular.to.pushNamed('/home/profile/followedDepts/', arguments: [company.id]);
  }

}
