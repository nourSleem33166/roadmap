import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:graphview/GraphView.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_graph/roadmap_graph_store.dart';
import 'package:roadmap/app/shared/models/roadmap_node.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';
import 'package:roadmap/generated/assets.dart';

import '../../../shared/theme/app_colors.dart';

class RoadmapGraphPage extends StatefulWidget {
  @override
  _RoadmapGraphPageState createState() => _RoadmapGraphPageState();
}

class _RoadmapGraphPageState extends State<RoadmapGraphPage> {
  final store = Modular.get<RoadmapGraphStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Observer(builder: (context) {
      return ComponentTemplate(
        state: store.pageState,
        screen: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(Assets.assetsBackground,
                  color: AppColors.primary.withOpacity(0.2),
                fit: BoxFit.fill,

              ),
            ),
            Column(mainAxisSize: MainAxisSize.max, children: [
              SizedBox(
                height: 40,
              ),
              Text(
                store.roadmap!.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: InteractiveViewer(
                      constrained: false,
                      scaleEnabled: true,
                      boundaryMargin: EdgeInsets.all(100),
                      minScale: 0.01,
                      maxScale: 5.6,
                      child: GraphView(
                          graph: store.graph,
                          animated: true,
                          algorithm: SugiyamaAlgorithm(store.builder),
                          paint: Paint()
                            ..color = AppColors.primary
                            ..strokeWidth = 2
                            ..isAntiAlias = false
                            ..style = PaintingStyle.stroke,
                          builder: (Node node) {
                            String value = node.key!.value;
                            return buildNode(store.nodes
                                .singleWhere((element) => element.id == value));
                          })))
            ]),
          ],
        ),
      );
    }));
  }

  Random r = Random();

  Widget sectionNode(RoadmapNode node) {
    return InkWell(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: AppColors.primary,
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
              child: Text(
            node.label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )),
        )),
      ),
    );
  }

  Widget buildNode(RoadmapNode node) {
    if (node.type == 'leaf')
      return leafNode(node);
    else if (node.type == 'section')
      return sectionNode(node);
    else
      return Container();
  }

  Widget leafNode(RoadmapNode node) {
    return InkWell(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xff4682b4),
        child: Container(

            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                  child: Text(
                node.label,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )),
            )),
      ),
    );
  }
}
