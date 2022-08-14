import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/profile/profile_repo.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

part 'favorite_companies_store.g.dart';

class FavoriteCompaniesStore = FavoriteCompaniesStoreBase with _$FavoriteCompaniesStore;

abstract class FavoriteCompaniesStoreBase with Store {
  ProfileRepo _repo;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  FavoriteCompaniesStoreBase(this._repo) {
    initValues();
  }

  List<CompanyModel> favoriteCompanies = [];

  @action
  Future initValues() async {
    pageState = ComponentState.FETCHING_DATA;
    favoriteCompanies = await _repo.getFavoriteCompanies();
    pageState = ComponentState.SHOW_DATA;
  }
}
