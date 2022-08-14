import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/explore/explore_repo.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/models/exam.dart';
import 'package:roadmap/app/shared/models/pagination_model.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';
import 'package:roadmap/app/shared/toasts/messages_toasts.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../shared/widgets/component_template.dart';

part 'explore_store.g.dart';

class ExploreStore = ExploreStoreBase with _$ExploreStore;

abstract class ExploreStoreBase with Store {
  ExploreRepo _repo;
  RoadmapRepo roadmapRepo;

  @observable
  ComponentState componentState = ComponentState.FETCHING_DATA;

  late PaginationModel<RoadmapModel> roadmapsPaginationModel;
  late PaginationModel<RoadmapModel> searchedRoadmapsPaginationModel;

  late PaginationModel<CompanyModel> companiesPaginationModel;
  late PaginationModel<CompanyModel> searchedCompaniesPaginationModel;

  FloatingSearchBarController floatingSearchBarController = FloatingSearchBarController();

  ScrollController roadmapsScrollController = ScrollController();
  ScrollController searchedRoadmapsScrollController = ScrollController();
  ScrollController companiesScrollController = ScrollController();
  ScrollController searchedCompaniesScrollController = ScrollController();

  ObservableList<RoadmapModel> roadmaps = ObservableList<RoadmapModel>();
  ObservableList<RoadmapModel> searchedRoadmaps = ObservableList<RoadmapModel>();
  ObservableList<CompanyModel> companies = ObservableList<CompanyModel>();
  ObservableList<CompanyModel> searchedCompanies = ObservableList<CompanyModel>();

  int roadmapsPage = 1;
  int companiesPage = 1;
  int searchedRoadmapsPage = 1;
  int searchedCompaniesPage = 1;

  @observable
  bool isLoading = false;
  @observable
  bool isCompanyLoading = false;

  @observable
  bool isRoadmapsSearchView = false;
  @observable
  bool isCompaniesSearchView = false;

  ExploreStoreBase(this._repo, this.roadmapRepo) {
    roadmapsScrollController.addListener(roadmapsPagination);
    searchedRoadmapsScrollController.addListener(searchedRoadmapsPagination);
    companiesScrollController.addListener(companiesPagination);
    searchedCompaniesScrollController.addListener(searchedCompaniesPagination);

    onQueryChanged("");
  }

  @observable
  ExploreType selectedExplore = ExploreType.Roadmaps;

  @action
  void changeSelectedExplore(ExploreType value) {
    selectedExplore = value;
  }

  @action
  Future<void> getRoadmaps(int pageKey) async {
    try {
      isRoadmapsSearchView = false;
      roadmapsPaginationModel = await _repo.getRoadmaps(pageKey, 10);
      roadmaps.addAll(roadmapsPaginationModel.items);
    } on AppException catch (e) {
      showErrorToast(e.message);
    }
  }

  @action
  Future<void> searchRoadmaps(int pageKey, [String? text]) async {
    try {
      isRoadmapsSearchView = true;
      searchedRoadmapsPaginationModel = await _repo.searchRoamaps(text, pageKey, 10);
      searchedRoadmaps.addAll(searchedRoadmapsPaginationModel.items);
    } on AppException catch (e) {
      showErrorToast(e.message);
    }
  }

  void handleNavigation(i) {
    if (i == 0)
      changeSelectedExplore(ExploreType.Roadmaps);
    else
      changeSelectedExplore(ExploreType.Companies);
    onQueryChanged("");
  }

  @action
  Future<void> getCompanies(int pageKey, [String? text]) async {
    try {
      isCompaniesSearchView = false;
      companiesPaginationModel = await _repo.getCompanies(pageKey, 10);
      companies.addAll(companiesPaginationModel.items);
    } catch (error) {}
  }

  @action
  Future<void> searchCompanies(int pageKey, [String? text]) async {
    try {
      isCompaniesSearchView = true;
      searchedCompaniesPaginationModel = await _repo.searchCompaines(text, pageKey, 10);
      searchedCompanies.addAll(searchedCompaniesPaginationModel.items);
    } catch (error) {}
  }

  void goToCompanyDetails(CompanyModel company) {
    Modular.to.pushNamed('/home/companyDetails/', arguments: [company.id]);
  }

  void goToRoadmap(RoadmapModel roadmap) {
    Modular.to.pushNamed('/home/roadmapDetails/', arguments: [roadmap.id]);
  }

  @action
  Future roadmapsPagination() async {
    if ((roadmapsScrollController.position.pixels ==
            roadmapsScrollController.position.maxScrollExtent) &&
        (roadmapsPaginationModel.currentPage < roadmapsPaginationModel.totalPages)) {
      isLoading = true;
      roadmapsPage += 1;
      await getRoadmaps(roadmapsPage);
      isLoading = false;
    }
  }

  @action
  Future searchedRoadmapsPagination() async {
    if ((searchedRoadmapsScrollController.position.pixels ==
            searchedRoadmapsScrollController.position.maxScrollExtent) &&
        (searchedRoadmapsPaginationModel.currentPage <
            searchedRoadmapsPaginationModel.totalPages)) {
      isLoading = true;
      searchedRoadmapsPage += 1;
      await searchRoadmaps(searchedRoadmapsPage);
      isLoading = false;
    }
  }

  @action
  Future searchedCompaniesPagination() async {
    if ((searchedCompaniesScrollController.position.pixels ==
            searchedCompaniesScrollController.position.maxScrollExtent) &&
        (searchedCompaniesPaginationModel.currentPage <
            searchedCompaniesPaginationModel.totalPages)) {
      isCompanyLoading = true;
      searchedCompaniesPage += 1;
      await searchCompanies(searchedCompaniesPage);
      isCompanyLoading = false;
    }
  }

  @action
  Future companiesPagination() async {
    runInAction(() async {
      if ((companiesScrollController.position.pixels ==
              companiesScrollController.position.maxScrollExtent) &&
          (companiesPaginationModel.currentPage < companiesPaginationModel.totalPages)) {
        isCompanyLoading = true;
        companiesPage += 1;
        await getCompanies(companiesPage);
        isCompanyLoading = false;
      }
    });
  }

  @action
  Future onQueryChanged(String? query) async {
    runInAction(() {
      componentState = ComponentState.FETCHING_DATA;
    });

    log("page state is ${componentState.name}");
    if (selectedExplore == ExploreType.Roadmaps) {
      if (query == null || query == "") {
        roadmaps.clear();
        roadmapsPage = 1;
        await getRoadmaps(roadmapsPage);
      } else {
        searchedRoadmaps.clear();
        searchedRoadmapsPage = 1;
        await searchRoadmaps(searchedRoadmapsPage, query);
      }
    } else {
      if (query == null || query == "") {
        companiesPage = 1;
        companies.clear();
        await getCompanies(companiesPage);
      } else {
        searchedCompanies.clear();
        searchedCompaniesPage = 1;
        await searchCompanies(searchedCompaniesPage, query);
      }
    }

    runInAction(() {
      componentState = ComponentState.SHOW_DATA;
    });
    log("page state2 is ${componentState.name}");
  }

  Future checkIfLearnerHasExam(BuildContext context) async {
    final exam = (await roadmapRepo.getActiveExam());
    if (exam != null) {
      showDialog(
          context: context,
          useRootNavigator: false,
          builder: (context) => Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Scaffold(
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.notifications,
                            color: AppColors.primary,
                            size: 50,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text('You have an active exam now, do you wish to proceed?'),
                          Spacer(),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Modular.to.pushNamed('/home/roadmapDetails/exam/',
                                          arguments: [
                                            Exam(exam: exam, exceptions: [])
                                          ]).then((value) {
                                        if (value == false) {
                                          showErrorToast('You Didn\'t pass the exam');
                                        }
                                      });
                                    },
                                    child: Text(
                                      'Yes',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'No',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          )
                        ]),
                      ),
                    )),
              ));
    }
  }
}

enum ExploreType { Roadmaps, Companies }
