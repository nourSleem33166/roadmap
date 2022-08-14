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

import '../optional_nodes_page.dart';

part 'roadmap_graph_store.g.dart';

class RoadmapGraphStore = RoadmapGraphStoreBase with _$RoadmapGraphStore;

abstract class RoadmapGraphStoreBase with Store {
  RoadmapRepo _roadmapRepo;

  RoadmapModel? roadmap;
  List<RoadmapNode> nodes = [];

   Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  String roadmapId = "";

  bool isLearningMode = false;

  RoadmapGraphStoreBase(this._roadmapRepo, String roadmapId, [bool isLearningMode = false]) {
    this.isLearningMode = isLearningMode;
    this.roadmapId = roadmapId;
    builder
      ..levelSeparation = (75)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT);
    getData();
  }

  @action
  Future<void> getData() async {
    try {
      pageState = ComponentState.FETCHING_DATA;
      roadmap = await _roadmapRepo.getRoadmapById(roadmapId);
      nodes = isLearningMode
          ? await _roadmapRepo.getLearningNodes(roadmapId)
          : await _roadmapRepo.getRoadmapNodes(roadmapId);
      // nodes.removeWhere((element) => element.label=='Props vs State' || element.label=='Component Life Cycle');
      mapNodes();
      pageState = ComponentState.SHOW_DATA;
    } on AppException catch (e) {
      pageState = ComponentState.ERROR;
      showErrorToast(e.message);
    }
  }

  bool isSectionOpen(RoadmapNode node) {
    final nodeChildren = nodes.where((element) => element.parents.contains(node.id));
    if (node.accessType == 'optional' || node.accessType == 'required') {
      if (nodeChildren
          .where((element) => element.accessType == 'required' && !element.isPassed!)
          .isEmpty) {
        return true;
      }
      if (nodeChildren.every((element) => element.accessType == 'optional')) {
        return true;
      }
      return false;
    } else {
      return nodeChildren.any((element) => element.isPassed!);
    }
  }

  Future mapNodes() async {
    graph.nodes.clear();
    graph.edges.clear();
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

  Future makeExam(BuildContext context, RoadmapNode node) async {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) => Dialog(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: OptionalNodesPage(nodes
                      .where((element) =>
                          element.id != node.id &&
                          element.type != 'roadmap' &&
                          element.isPassed != true)
                      .toList())),
            )).then((value) {
      if (value != null) {
        _roadmapRepo
            .startExam(
                roadmapId, node.id, (value as List<RoadmapNode>).map((e) => e.id).toList())
            .then((value) {
          if (value.exceptions.isEmpty) {
            Modular.to.pushNamed('/home/roadmapDetails/exam/', arguments: [value]).then(
                (passedExam) {
              if (passedExam != null) {
                if (passedExam as bool) {
                } else {
                  showErrorToast('Exam Not Passed');
                }
              }
              getData();
            });
          }
        });
      }
    });
  }

  void downloadCertificate() {}
}
