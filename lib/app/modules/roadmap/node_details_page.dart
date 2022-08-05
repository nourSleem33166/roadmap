import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/shared/models/roadmap_node.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../comments/comments_page.dart';
import '../comments/comments_repo.dart';

class NodeDetailsPage extends StatefulWidget {
  RoadmapNode node;

  NodeDetailsPage(this.node);

  @override
  _NodeDetailsPageState createState() => _NodeDetailsPageState();
}

class _NodeDetailsPageState extends State<NodeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                child: Column(children: [
              Text(
                '${widget.node.label} Details',
                style:
                    Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.primary),
              ),
              Divider(thickness: 1.5),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Supplements',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.node.supplements
                      .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: InkWell(
                              onTap: () async {
                                await launchUrl(Uri.parse(e));
                              },
                              child: Text('- $e',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: AppColors.primary)))))
                      .toList()),
              SizedBox(height: 10),
              Column(children: [
                Row(children: [
                  Text('Node Type: ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith()),
                  Text(widget.node.type.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold, color: AppColors.primary))
                ]),
                SizedBox(height: 10),
                Row(children: [
                  Text('Node Requirement Type: ',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith()),
                  Text(widget.node.accessType.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold, color: AppColors.primary))
                ])
              ]),
              SizedBox(height: 30),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        goToComments(context);
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Show Comments',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: AppColors.white, fontSize: 16)))),
                ),
                SizedBox(width: 10),
                Visibility(
                    visible: widget.node.type == 'roadmap',
                    child: Expanded(
                        child: ElevatedButton(
                            onPressed: () => goToRoadmapDetails(widget.node.referenceId!),
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('Show Roadmap',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: AppColors.white, fontSize: 16))))))
              ])
            ]))));
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
                height: 80.h,
                child: CommentsPage(widget.node.id, CommentsRepo(dio, 'nodes'))),
          );
        });
  }

  void goToRoadmapDetails(String id) {
    Modular.to.pushNamed('/home/roadmapDetails/', arguments: [id]);
  }
}
