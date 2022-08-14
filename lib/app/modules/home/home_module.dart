import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/company/company_module.dart';
import 'package:roadmap/app/modules/explore/explore_page.dart';
import 'package:roadmap/app/modules/explore/explore_repo.dart';
import 'package:roadmap/app/modules/notifications/notifications_page.dart';
import 'package:roadmap/app/modules/profile/profile_module.dart';
import 'package:roadmap/app/modules/profile/profile_repo.dart';
import 'package:roadmap/app/modules/profile/profile_store.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_module.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_repo.dart';
import 'package:roadmap/app/modules/scheduler/scheduler_module.dart';
import 'package:roadmap/app/modules/scheduler/scheduler_repo.dart';
import 'package:roadmap/app/shared/repos/follow_process_repo.dart';

import '../company/company_repo.dart';
import '../explore/explore_store.dart';
import '../home/home_store.dart';
import '../notifications/notifications_store.dart';
import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ExploreRepo(i.get<Dio>())),
    Bind((i) => RoadmapRepo(i.get<Dio>())),
    Bind.lazySingleton((i) => HomeStore()),
    Bind((i) => ExploreStore(i.get<ExploreRepo>(), i.get<RoadmapRepo>())),
    Bind((i) => ProfileRepo(i.get<Dio>())),
    Bind((i) => ProfileStore(i.get<ProfileRepo>())),
    Bind((i) => NotificationsStore()),
    Bind((i) => CompanyRepo(i.get<Dio>())),
    Bind((i) => FollowProcessRepo(i.get<Dio>())),
    Bind((i) => SchedulerRepo(i.get<Dio>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => HomePage(), children: [
      ChildRoute(
        '/explore/',
        child: (_, args) => ExplorePage(),
      ),
      ChildRoute(
        '/notifications/',
        child: (_, args) => NotificationsPage(),
      ),
      ModuleRoute(
        '/profile/',
        module: ProfileModule(),
      )
    ]),
    ModuleRoute('/companyDetails/', module: CompanyModule()),
    ModuleRoute('/roadmapDetails/', module: RoadmapModule()),

  ];
}
