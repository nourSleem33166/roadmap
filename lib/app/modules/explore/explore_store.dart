import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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

part 'explore_store.g.dart';

class ExploreStore = ExploreStoreBase with _$ExploreStore;

abstract class ExploreStoreBase with Store {
  ExploreRepo _repo;
  RoadmapRepo roadmapRepo;

  late PaginationModel<RoadmapModel> roadmaps;
  late PaginationModel<CompanyModel> companies;
  final PagingController<int, RoadmapModel> roadmapsPagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, CompanyModel> companiesPagingController =
      PagingController(firstPageKey: 1);

  FloatingSearchBarController floatingSearchBarController = FloatingSearchBarController();

  ExploreStoreBase(this._repo, this.roadmapRepo) {
    roadmapsPagingController.addPageRequestListener((pageKey) {
      getRoadmaps(pageKey);
    });
    companiesPagingController.addPageRequestListener((pageKey) {
      getCompanies(pageKey);
    });
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
                                          arguments: [Exam(exam: exam, exceptions: [])]);
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

  @observable
  ExploreType selectedExplore = ExploreType.Roadmaps;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  @action
  void changeSelectedExplore(ExploreType value) {
    selectedExplore = value;
  }

  Future<void> getRoadmaps(int pageKey, [String? text]) async {
    try {
      if (text == null || text == "") {
        roadmaps = await _repo.getRoadmaps(pageKey, 10);
      } else {
        roadmaps = await _repo.searchRoamaps(text, pageKey, 10);
      }
      if (roadmaps.currentPage == roadmaps.totalPages) {
        roadmapsPagingController.appendLastPage(roadmaps.items);
      } else {

        final nextPageKey = pageKey + 1;
        roadmapsPagingController.appendPage(roadmaps.items, nextPageKey);
      }
    } on AppException catch (e) {
      showErrorToast(e.message);
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
