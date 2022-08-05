import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/company/department/department_page.dart';
import 'package:roadmap/app/modules/company/department/department_store.dart';
import 'package:roadmap/app/shared/repos/follow_process_repo.dart';

import 'company_page.dart';
import 'company_repo.dart';
import 'company_store.dart';

class CompanyModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) =>
        CompanyStore(i.get<CompanyRepo>(), i.get<FollowProcessRepo>(), i.args.data[0])),
    Bind((i) => DeptStore(
        i.get<CompanyRepo>(), i.get<FollowProcessRepo>(), i.args.data[0], i.args.data[1])),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => CompanyPage()),
    ChildRoute('/deptDetails', child: (_, args) => DeptPage()),
  ];
}
