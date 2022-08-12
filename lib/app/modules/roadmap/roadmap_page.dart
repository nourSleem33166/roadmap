import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_store.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../shared/theme/app_colors.dart';

class RoadmapPage extends StatefulWidget {
  const RoadmapPage({Key? key}) : super(key: key);

  @override
  _RoadmapPageState createState() => _RoadmapPageState();
}

class _RoadmapPageState extends ModularState<RoadmapPage, RoadmapStore> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Observer(builder: (context) {
          return ComponentTemplate(
            state: store.pageState,
            onRetry: () => store.getData(),
            screen: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                upperSection(context),
                Expanded(child: SingleChildScrollView(child: _buildAbout(context)))
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAbout(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            children: [
              Text(
                'About ${store.roadmap?.title}',
                style: theme.textTheme.headline5!
                    .copyWith(color: theme.primaryColor, fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            store.roadmap?.description ?? "",
            style: theme.textTheme.bodyText2,
          ),
          SizedBox(
            height: 20,
          ),
          viewRoadmapButton(context),
          SizedBox(
            height: 10,
          )
        ]));
  }

  Widget _buildInfoItem(BuildContext context, String title, String text) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyText2!.copyWith(fontSize: 24, color: theme.primaryColor),
        ),
        Text(
          text,
          style: theme.textTheme.bodyText2!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget viewRoadmapButton(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
        onPressed: () {
          store.goToRoadmapGraph();
        },
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Text(
            'View Roadmap Graph',
            style: theme.textTheme.bodyText1!.copyWith(fontSize: 14, color: AppColors.white),
          ),
        ));
  }

  Widget upperSection(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(store.company?.coverImage ?? ""))),
        ),
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        Positioned(
          top: 50,
          right: 1,
          left: 1,
          child: Container(
            width: 60,
            height: 60,
            child: CircleAvatar(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: Image.network(store.company?.logo ?? ""))),
          ),
        ),
        Positioned(
          top: 110,
          right: 1,
          left: 1,
          child: Text(
            store.roadmap?.title ?? "",
            textAlign: TextAlign.center,
            style: theme.textTheme.headline5!.copyWith(color: AppColors.white),
          ),
        ),
        Positioned(
          top: 140,
          right: 1,
          left: 1,
          child: Text(
            'A Roadmap By ${store.department?.name}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyText2!.copyWith(color: AppColors.white),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 70,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30), topLeft: Radius.circular(30))),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.5,
              height: 60,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30), topLeft: Radius.circular(30))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (store.roadmap?.learnStatus == LearnStatus.None) {
                          store.startLearningRoadmapGraph();
                        }
                        else   if (store.roadmap?.learnStatus == LearnStatus.Learning) {
                          store.continueLearning();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text(
                          store.roadmap?.learnStatus == LearnStatus.None
                              ? 'Schedule To Me'
                              : store.roadmap?.learnStatus == LearnStatus.Learned
                                  ? 'Learned ✔'
                                  : 'Learning Now ⌛',
                          style: theme.textTheme.bodyText1!
                              .copyWith(fontSize: 14, color: AppColors.white),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            left: 5,
            child: Container(
                width: 60,
                height: 60,
                child: IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.white, size: 25),
                    onPressed: () {
                      Modular.to.pop();
                    }))),
      ],
    );
  }
}
