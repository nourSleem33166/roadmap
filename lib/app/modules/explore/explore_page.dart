import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:roadmap/app/modules/explore/explore_store.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../shared/widgets/component_template.dart';
import 'explore_store.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends ModularState<ExplorePage, ExploreStore> {
  @override
  void initState() {
    super.initState();
    store.checkIfLearnerHasExam(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: Colors.white60,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              SliverAppBar(
                  title: Container(
                      color: theme.scaffoldBackgroundColor,
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      height: 80,
                      child: Center(child: buildFloatingSearchBar())),
                  backgroundColor: theme.scaffoldBackgroundColor,
                  floating: true,
                  pinned: true,
                  snap: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(0),
                    child: SizedBox.shrink(),
                  )),
            ];
          },
          body: Column(children: [
            Row(mainAxisSize: MainAxisSize.max, children: [
              Observer(builder: (context) {
                return Expanded(
                  child: SalomonBottomBar(
                    currentIndex: store.selectedExplore == ExploreType.Roadmaps ? 0 : 1,
                    onTap: (i) => store.handleNavigation(i),
                    items: [
                      SalomonBottomBarItem(
                        icon: Icon(FontAwesomeIcons.graduationCap, size: 20),
                        title: Text("Roadmap",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: AppColors.gold, fontSize: 14)),
                        selectedColor: AppColors.gold,
                      ),

                      /// Home
                      SalomonBottomBarItem(
                        icon: Icon(Icons.copyright_outlined, size: 20),
                        title: Text("Companies",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: theme.primaryColor, fontSize: 14)),
                        selectedColor: theme.primaryColor,
                      ),
                    ],
                    margin: EdgeInsets.all(5),
                    itemPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                    itemShape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                );
              }),
            ]),
            Observer(
              builder: (context) {
                return ComponentTemplate(
                  state: store.componentState,
                  screen: Expanded(
                      child: store.selectedExplore == ExploreType.Roadmaps
                          ? roadmapsList(context)
                          : companiesList(context)),
                );
              }
            )
          ]),
        ));
  }

  Widget roadmapsList(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        if (store.isRoadmapsSearchView)
          return ListView.builder(
              controller: store.searchedRoadmapsScrollController,
              itemCount: store.searchedRoadmaps.length,
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: roadmapItem(store.searchedRoadmaps[index]),
                  ));
        else
          return ListView.builder(
              controller: store.roadmapsScrollController,
              itemCount: store.roadmaps.length,
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: roadmapItem(store.roadmaps[index]),
                  ));
      },
    );
  }

  Widget companiesList(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        if (store.isCompaniesSearchView)
          return ListView.builder(
              controller: store.searchedCompaniesScrollController,
              itemCount: store.searchedCompanies.length,
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: companyItem(context, store.searchedCompanies[index]),
                  ));
        else
          return ListView.builder(
              controller: store.companiesScrollController,
              itemCount: store.companies.length,
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: companyItem(context, store.companies[index]),
                  ));
      },
    );
  }

  Widget buildFloatingSearchBar() {
    final theme = Theme.of(context);
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      initiallyHidden: false,
      margins: EdgeInsets.zero,
      shadowColor: theme.scaffoldBackgroundColor,
      backgroundColor: theme.scaffoldBackgroundColor,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      backdropColor: theme.scaffoldBackgroundColor,
      iconColor: theme.primaryColor,
      controller: store.floatingSearchBarController,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      body: SizedBox.shrink(),
      height: 60,
      width: MediaQuery.of(context).size.width,
      debounceDelay: const Duration(seconds: 2),
      onQueryChanged: (query) {
        setState(() {
          store.onQueryChanged(query);
        });
      },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return SizedBox.shrink();
      },
    );
  }

  Widget roadmapItem(RoadmapModel roadmap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        store.goToRoadmap(roadmap);
      },
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        roadmap.title,
                        style: theme.textTheme.headline5!.copyWith(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Column(children: [
                    Text(
                      roadmap.description,
                      style: theme.textTheme.bodyText2,
                      maxLines: 4,
                    )
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        _buildInfoItem(
                            context, roadmap.company?.name ?? "", FontAwesomeIcons.suitcase),
                        Spacer(),
                        _buildInfoItem(context, roadmap.department?.name ?? "",
                            FontAwesomeIcons.suitcase),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        _buildInfoItem(context, DateFormat('yyyy MMM dd').format(roadmap.createdAt),
                            FontAwesomeIcons.calendarMinus),
                      ],
                    ),
                    // SizedBox(height: 15,),
                    Row(
                      children: [
                        // _buildInfoItem(context,company.website,FontAwesomeIcons.globe),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(thickness: 2),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget companyItem(BuildContext context, CompanyModel company) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        store.goToCompanyDetails(company);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          fit: BoxFit.cover, image: NetworkImage(company.coverImage ?? ""))),
                ),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
                Positioned(
                  bottom: 80,
                  right: 1,
                  left: 1,
                  child: Container(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.network(company.logo ?? ""))),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 1,
                  left: 1,
                  child: Text(
                    company.name,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline5!.copyWith(color: AppColors.white),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 1,
                  left: 1,
                  child: Text(
                    company.workDomain?.text??"",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyText2!.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String text, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.primaryColor),
          SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: theme.textTheme.bodyText2!.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
