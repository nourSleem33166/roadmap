import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/shared/services/storage_service.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../shared/models/user.dart';

part 'profile_store.g.dart';

class ProfileStore = ProfileStoreBase with _$ProfileStore;

abstract class ProfileStoreBase with Store {
  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  ProfileStoreBase() {
    initValues();
  }

  User? user;

  @action
  Future initValues() async {
    pageState = ComponentState.FETCHING_DATA;
    user = await SharedPreferencesHelper.getUser();
    pageState = ComponentState.SHOW_DATA;
  }

  void goToScheduler() {
    Modular.to.pushNamed('/home/scheduler/', arguments: ['']);
  }
}
