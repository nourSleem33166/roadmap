import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/explore/explore_repo.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/models/pagination_model.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

part 'explore_store.g.dart';

class ExploreStore = ExploreStoreBase with _$ExploreStore;

abstract class ExploreStoreBase with Store {
  ExploreRepo _repo;

  late PaginationModel<RoadmapModel> roadmaps;
  late PaginationModel<CompanyModel> companies;
  final PagingController<int, RoadmapModel> roadmapsPagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, CompanyModel> companiesPagingController =
      PagingController(firstPageKey: 1);

  FloatingSearchBarController floatingSearchBarController =
      FloatingSearchBarController();

  ExploreStoreBase(this._repo) {
    roadmapsPagingController.addPageRequestListener((pageKey) {
      getRoadmaps(pageKey);
    });
    companiesPagingController.addPageRequestListener((pageKey) {
      getCompanies(pageKey);
    });
  }

  @observable
  ExploreType selectedExplore = ExploreType.Roadmaps;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  // Future getData() async {
  //   try {
  //     pageState = ComponentState.FETCHING_DATA;
  //     if (selectedExplore == ExploreType.Roadmaps)
  //       roadmaps = await _repo.getRoadmaps();
  //     else
  //       companies = await _repo.getCompanies();
  //     pageState = ComponentState.SHOW_DATA;
  //   } on AppException catch (e) {
  //     showErrorToast(e.message);
  //     pageState = ComponentState.ERROR;
  //   }
  // }

  @action
  void changeSelectedExplore(ExploreType value) {
    selectedExplore = value;
  }

  Future<void> getRoadmaps(int pageKey, [String? text]) async {
    if (text == null || text == "") {
      roadmaps = await _repo.getRoadmaps(pageKey, 10);
    } else {
      roadmapsPagingController.refresh();
      roadmaps = await _repo.searchRoamaps(text, pageKey, 10);
    }

    if (roadmaps.currentPage == roadmaps.totalPages) {
      roadmapsPagingController.appendLastPage(roadmaps.items);
    } else {
      final nextPageKey = pageKey + 1;
      roadmapsPagingController.appendPage(roadmaps.items, nextPageKey);
    }
  }

  void handleNavigation(i) {
    if (i == 0)
      changeSelectedExplore(ExploreType.Roadmaps);
    else
      changeSelectedExplore(ExploreType.Companies);
  }

  Future<void> getCompanies(int pageKey, [String? text]) async {
    try {
      if (text == null || text == "")
        companies = await _repo.getCompanies(pageKey, 10);
      else {
        companiesPagingController.refresh();
        companies = await _repo.searchCompaines(text, pageKey, 10);
      }

      if (companies.currentPage == companies.totalPages) {
        companiesPagingController.appendLastPage(companies.items);
      } else {
        final nextPageKey = pageKey + 1;
        companiesPagingController.appendPage(companies.items, nextPageKey);
      }
    } catch (error) {
      companiesPagingController.error = error;
    }
  }

  void goToCompanyDetails(CompanyModel company) {
    Modular.to.pushNamed('/home/companyDetails/', arguments: [company.id]);
  }

  void goToRoadmap(RoadmapModel roadmap) {
    Modular.to.pushNamed('/home/roadmapDetails/', arguments: [roadmap.id]);
  }
}

enum ExploreType { Roadmaps, Companies }
