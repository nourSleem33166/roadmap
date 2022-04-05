import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/auth/login/login_page.dart';
import 'package:roadmap/app/modules/auth/login/login_store.dart';
import 'package:roadmap/app/modules/auth/sign_up/sign_up_page.dart';
import 'package:roadmap/app/modules/auth/sign_up/sign_up_store.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => LoginStore()),
    Bind((i) => SignUpStore())
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => LoginPage()),
    ChildRoute('/signup/', child: (_, args) => SignUpPage()),
  ];
}
