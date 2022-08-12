import 'package:calendar_view/calendar_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/explore/explore_repo.dart';
import 'package:roadmap/app/modules/profile/profile_store.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_repo.dart';
import 'package:roadmap/app/modules/scheduler/scheduler_page.dart';
import 'package:roadmap/app/modules/scheduler/scheduler_repo.dart';
import 'package:roadmap/app/modules/scheduler/scheduler_store.dart';
import 'package:roadmap/app/shared/repos/follow_process_repo.dart';

import '../company/company_repo.dart';
import '../explore/explore_store.dart';
import '../home/home_store.dart';
import '../notifications/notifications_store.dart';

class SchedulerModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory(
        (i) => SchedulerStore(i.get<SchedulerRepo>(), i.get<RoadmapRepo>(), i.args.data[0])),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => CalendarControllerProvider(
      controller: EventController(),
        child: SchedulerPage()))
  ];
}
