import 'package:graphview/GraphView.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/models/roadmap_node.dart';
import 'package:roadmap/app/shared/toasts/messages_toasts.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

part 'roadmap_graph_store.g.dart';

class RoadmapGraphStore = RoadmapGraphStoreBase with _$RoadmapGraphStore;

abstract class RoadmapGraphStoreBase with Store {
  RoadmapRepo _roadmapRepo;

  RoadmapModel? roadmap;
  List<RoadmapNode> nodes = [];

  final Graph graph = Graph()..isTree = true;
  SugiyamaConfiguration builder = SugiyamaConfiguration(

  );


  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  String roadmapId = "";

  RoadmapGraphStoreBase(this._roadmapRepo, String roadmapId) {
    this.roadmapId = roadmapId;
    builder
      ..levelSeparation = (40)
      ..orientation = (SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM)..nodeSeparation=10;
    getData();
  }

  @action
  Future<void> getData() async {
    try {
      pageState = ComponentState.FETCHING_DATA;
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
      for (final parent in node.parents)
        graph.addEdge(Node.Id(parent), Node.Id(node.id));
  }
}
