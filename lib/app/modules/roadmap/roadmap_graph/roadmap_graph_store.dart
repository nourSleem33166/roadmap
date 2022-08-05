import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:graphview/GraphView.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/comments/comments_page.dart';
import 'package:roadmap/app/modules/comments/comments_repo.dart';
import 'package:roadmap/app/modules/roadmap/node_details_page.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/models/roadmap_node.dart';
import 'package:roadmap/app/shared/toasts/messages_toasts.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';
import 'package:sizer/sizer.dart';

part 'roadmap_graph_store.g.dart';

class RoadmapGraphStore = RoadmapGraphStoreBase with _$RoadmapGraphStore;

abstract class RoadmapGraphStoreBase with Store {
  RoadmapRepo _roadmapRepo;

  RoadmapModel? roadmap;
  List<RoadmapNode> nodes = [];

  final Graph graph = Graph()..isTree = true;
  SugiyamaConfiguration builder = SugiyamaConfiguration();

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  String roadmapId = "";

  RoadmapGraphStoreBase(this._roadmapRepo, String roadmapId) {
    this.roadmapId = roadmapId;
    builder
      ..levelSeparation = (40)
      ..orientation = (SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM)
      ..nodeSeparation = 10;
    getData();
  }

  @action
  Future<void> getData() async {
    try {
      roadmap = await _roadmapRepo.getRoadmapById(roadmapId);
      nodes = await _roadmapRepo.getRoadmapNodes(roadmapId);
      mapNodes();
      pageState = ComponentState.SHOW_DATA;
    } on AppException catch (e) {
      pageState = ComponentState.ERROR;
      showErrorToast(e.message);
    }
  }

  Future mapNodes() async {
    for (final node in nodes) graph.addNode(Node.Id(node.id));
    for (final node in nodes)
      for (final parent in node.parents) graph.addEdge(Node.Id(parent), Node.Id(node.id));
  }

  void goToComments(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          final dio = Modular.get<Dio>();
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
                height: 80.h, child: CommentsPage(roadmapId, CommentsRepo(dio, 'roadmaps'))),
          );
        });
  }

  showNodeDialog(BuildContext context, RoadmapNode roadmapNode) {
    showBottomSheet(
        context: context,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(40), topLeft: Radius.circular(40))),
        builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ClipRRect(
                  child: NodeDetailsPage(roadmapNode),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40), topLeft: Radius.circular(40))),
            ));
  }
}
