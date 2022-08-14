import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/shared/services/storage_service.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  HomeStoreBase() {
    Modular.to.navigate('/home/explore/');
  }

  @observable
  int currentDrawerIndex = 1;

  Future<void> logout() async {
    await SharedPreferencesHelper.deleteUser();
    Modular.to.pushNamedAndRemoveUntil('/auth/', (p0) => false);
  }

  navigateToProfile() {
    if (!Modular.to.path.contains('profile'))
      Modular.to.navigate('/home/profile/');
  }

  navigateToExplore() {
    if (!Modular.to.path.contains('explore')) Modular.to.navigate('/home/explore/');
  }

  navigateToNotifications() {
    if (!Modular.to.path.contains('notifications'))
      Modular.to.navigate('/home/notifications/');
  }

  @action
  void handleNavigation(int i) {
    currentDrawerIndex = i;
    if (i == 0)
      navigateToProfile();
    else if (i == 1)
      navigateToExplore();
    else
      navigateToNotifications();
  }
}
