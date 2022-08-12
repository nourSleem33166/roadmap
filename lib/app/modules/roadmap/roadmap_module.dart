import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/comments/replies/replies_store.dart';
import 'package:roadmap/app/modules/comments/update_comment_page.dart';
import 'package:roadmap/app/modules/company/company_repo.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_exam/roadmap_exam_page.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_exam/roadmap_exam_store.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_graph/roadmap_graph_page.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_graph/roadmap_graph_store.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_page.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_repo.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_store.dart';

import '../comments/comments_store.dart';

class RoadmapModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => RoadmapStore(i.get<RoadmapRepo>(), i.get<CompanyRepo>(), i.args.data[0])),
    Bind.factory(
        (i) => RoadmapGraphStore(i.get<RoadmapRepo>(), i.args.data[0], i.args.data[1])),
    Bind((i) => CommentsStore(), isSingleton: false, isLazy: true),
    Bind((i) => RepliesStore(), isSingleton: false, isLazy: true),
    Bind((i) => ExamStore(i.get<RoadmapRepo>(), i.args.data[0]))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => RoadmapPage()),
    ChildRoute('/roadmapGraph/', child: (_, args) => RoadmapGraphPage()),
    ChildRoute('/exam/', child: (_, args) => ExamPage()),
    ChildRoute('/updateComment/', child: (_, args) => UpdateCommentPage(args.data[0])),
  ];
}
