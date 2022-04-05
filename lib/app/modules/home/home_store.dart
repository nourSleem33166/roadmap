import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/shared/services/storage_service.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  Future<void> logout() async {
    await SharedPreferencesHelper.deleteUser();
    Modular.to.pushReplacementNamed('/auth/');
  }
}
