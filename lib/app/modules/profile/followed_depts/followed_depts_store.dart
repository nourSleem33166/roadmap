import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/profile/profile_repo.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/models/department.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

part 'followed_depts_store.g.dart';

class FollowedDeptsStore = FollowedDpetsStoreBase with _$FollowedDeptsStore;

abstract class FollowedDpetsStoreBase with Store {
  ProfileRepo _repo;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  String companyId;

  FollowedDpetsStoreBase(this._repo, this.companyId) {
    initValues();
  }

  List<Department> followedDepts = [];

  @action
  Future initValues() async {
    pageState = ComponentState.FETCHING_DATA;
    followedDepts = await _repo.getFollowedDepts(companyId);
    pageState = ComponentState.SHOW_DATA;
  }


}
