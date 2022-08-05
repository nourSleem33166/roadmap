import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/comments/replies/replies_store.dart';
import 'package:roadmap/app/modules/company/company_repo.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_graph/roadmap_graph_page.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_graph/roadmap_graph_store.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_page.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_repo.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_store.dart';

import '../comments/comments_store.dart';

class RoadmapModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => RoadmapRepo(i.get<Dio>())),
    Bind((i) => RoadmapStore(
        i.get<RoadmapRepo>(), i.get<CompanyRepo>(), i.args.data[0])),
    Bind((i) => RoadmapGraphStore(i.get<RoadmapRepo>(), i.args.data[0])),
    Bind((i) => CommentsStore(), isSingleton: false, isLazy: true),
    Bind((i) => RepliesStore(), isSingleton: false, isLazy: true),

  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => RoadmapPage()),
    ChildRoute('/roadmapGraph/', child: (_, args) => RoadmapGraphPage()),
  ];
}
