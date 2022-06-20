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
  late RoadmapGraphStore store;

  @override
  void initState() {
    super.initState();
    store = Modular.get<RoadmapGraphStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Observer(builder: (context) {
      return ComponentTemplate(
        state: store.pageState,
        screen: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                Assets.assetsBackground,
                color: AppColors.primary.withOpacity(0.2),
                fit: BoxFit.fill,
              ),
            ),
            Observer(
              builder: (context) {
                return Column(mainAxisSize: MainAxisSize.max, children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10,),
                      Text(
                        "${store.roadmap!.title} Roadmap ",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            store.goToComments(context);
                          },
                          child: Icon(
                            Icons.message,
                            color: AppColors.white,
                            size: 20,
                          )),
                      SizedBox(width: 10,),


                    ],
                  ),
                  Observer(
                    builder: (context) {
                      return Expanded(
                          child: InteractiveViewer(
                              constrained: false,
                              scaleEnabled: true,
                              boundaryMargin: EdgeInsets.all(1000),
                              minScale: 0.01,
                              maxScale: 5.6,
                              child: GraphView(
                                  graph: store.graph,
                                  animated: true,
                                  algorithm: SugiyamaAlgorithm(store.builder),
                                  paint: Paint()
                                    ..color = Color(0xff323232)
                                    ..strokeWidth = 2
                                    ..isAntiAlias = false
                                    ..style = PaintingStyle.stroke,
                                  builder: (Node node) {
                                    String value = node.key!.value;
                                    return buildNode(store.nodes
                                        .singleWhere((element) => element.id == value));
                                  })));
                    }
                  )
                ]);
              }
            ),
          ],
        ),
      );
    }));
  }

  Widget sectionNode(RoadmapNode node) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xff1f4690),
        child: Stack(
          children: [
            Positioned(
              left: 1,
              right: 1,
              top: 1,
              child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    Assets.assetsPiechart,
                    width: 30,
                    height: 30,
                  )),
            ),
            Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
              child: Center(
                  child: Text(
                node.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
            )),
          ],
        ),
      ),
    );
  }

  Widget buildNode(RoadmapNode node) {
    if (node.type == 'leaf')
      return leafNode(node);
    else if (node.type == 'section')
      return sectionNode(node);
    else
      return roadmapNode(node);
  }

  Widget leafNode(RoadmapNode node) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xff36ae7c),
        child: Stack(
          children: [
            Positioned(
              right: 1,
              left: 1,
              bottom: 5,
              child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    Assets.assetsLeaf,
                    width: 45,
                    height: 45,
                  )),
            ),
            Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
              child: Center(
                  child: Text(
                node.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )),
            )),
          ],
        ),
      ),
    );
  }

  Widget roadmapNode(RoadmapNode node) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xffeb5353),
        child: Stack(
          children: [
            Positioned(
              right: 1,
              left: 1,
              top: 5,
              child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    Assets.assetsTrack,
                    width: 55,
                    height: 55,
                  )),
            ),
            Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
              child: Center(
                  child: Text(
                node.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )),
            )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
