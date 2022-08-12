import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:roadmap/app/shared/models/roadmap_node.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';

class OptionalNodesPage extends StatefulWidget {
  List<RoadmapNode> nodes;

  OptionalNodesPage(this.nodes);

  @override
  _OptionalNodesPageState createState() => _OptionalNodesPageState();
}

class _OptionalNodesPageState extends State<OptionalNodesPage> {
  List<RoadmapNode> selectedNodes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Select optional nodes to add to your exam',
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.nodes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: nodeTile(widget.nodes[index], context),
                    );
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(selectedNodes);
                },
                child: Text('Submit',
                    style:
                    Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.white)))
          ],
        ),
      ),
    );
  }

  Widget nodeTile(RoadmapNode node, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: ListTile(
        selectedTileColor: AppColors.primary.withOpacity(0.2),
        title: Text(node.label, style: Theme.of(context).textTheme.titleMedium),
        selected: selectedNodes.contains(node),
        onTap: () {
          setState(() {
            if (selectedNodes.contains(node)) {
              selectedNodes.remove(node);
            } else {
              selectedNodes.add(node);
            }
          });
        },
      ),
    );
  }
}
