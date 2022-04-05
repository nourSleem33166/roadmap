import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/auth/auth_module.dart';
import 'package:roadmap/app/modules/auth/auth_repo.dart';
import 'package:roadmap/app/modules/splash/splash_page.dart';

import '../app/shared/dio/factory.dart';
import 'modules/home/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => DioFactory.create()),
    Bind.singleton((i) => AuthRepo(i.get<Dio>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => SplashPage()),
    ModuleRoute('/home/', module: HomeModule()),
    ModuleRoute('/auth/', module: AuthModule())
  ];
}
