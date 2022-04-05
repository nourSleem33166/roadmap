import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/auth/auth_repo.dart';
import 'package:roadmap/app/modules/auth/login/login_page.dart';
import 'package:roadmap/app/modules/auth/login/login_store.dart';
import 'package:roadmap/app/modules/auth/sign_up/sign_up_page.dart';
import 'package:roadmap/app/modules/auth/sign_up/sign_up_store.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => LoginStore(i.get<AuthRepo>())),
    Bind((i) => SignUpStore(i.get<AuthRepo>()))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute,
        child: (_, args) => LoginPage(), transition: TransitionType.upToDown),
    ChildRoute('/signup/', child: (_, args) => SignUpPage(),transition: TransitionType.downToUp),
  ];
}
