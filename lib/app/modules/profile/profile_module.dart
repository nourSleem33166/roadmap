import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/profile/favorite_companies/favorite_companies_page.dart';
import 'package:roadmap/app/modules/profile/favorite_companies/favorite_companies_store.dart';
import 'package:roadmap/app/modules/profile/followed_companies/followed_companies_page.dart';
import 'package:roadmap/app/modules/profile/followed_companies/followed_companies_store.dart';
import 'package:roadmap/app/modules/profile/followed_depts/followed_depts_page.dart';
import 'package:roadmap/app/modules/profile/followed_depts/followed_depts_store.dart';
import 'package:roadmap/app/modules/profile/profile_page.dart';
import 'package:roadmap/app/modules/profile/profile_repo.dart';
import 'package:roadmap/app/modules/profile/profile_store.dart';

import '../scheduler/scheduler_module.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ProfileRepo(i.get<Dio>())),
    Bind((i) => ProfileStore(i.get<ProfileRepo>())),
    Bind((i) => FollowedCompaniesStore(i.get<ProfileRepo>())),
    Bind((i) => FavoriteCompaniesStore(i.get<ProfileRepo>())),
    Bind((i) => FollowedDeptsStore(i.get<ProfileRepo>(), i.args.data[0])),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ProfilePage()),
    ChildRoute(
      '/followedCompanies/',
      child: (_, args) => FollowedCompaniesPage(),
    ),
    ChildRoute(
      '/favoriteCompanies/',
      child: (_, args) => FavoriteCompaniesPage(),
    ),
    ChildRoute(
      '/followedDepts/',
      child: (_, args) => FollowedDeptsPage(),
    ),
    ModuleRoute(
      '/scheduler/',
      module: SchedulerModule(),
    )
  ];
}
