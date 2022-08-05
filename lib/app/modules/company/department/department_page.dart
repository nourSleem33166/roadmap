import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/company/department/department_store.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../../shared/theme/app_colors.dart';

class DeptPage extends StatefulWidget {
  const DeptPage({Key? key}) : super(key: key);

  @override
  _DeptPageState createState() => _DeptPageState();
}

class _DeptPageState extends ModularState<DeptPage, DeptStore> {
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
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                  children: [_buildAbout(context), _buildRoadmaps(context)],
                )))
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
                'About this Dept',
                style: theme.textTheme.headline5!
                    .copyWith(color: theme.primaryColor, fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            store.department?.description ?? "",
            style: theme.textTheme.bodyText2!.copyWith(fontSize: 18),
          ),
        ]));
  }

  Widget _buildRoadmaps(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Roadmaps Featured by ${store.department?.name}',
                style: theme.textTheme.headline5!
                    .copyWith(color: theme.primaryColor, fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: store.roadmaps!
                  .map((roadmap) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            store.goToRoadmapDetails(roadmap);
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: Container(
                                width: (MediaQuery.of(context).size.width / 2) - 30,
                                height: 250,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  NetworkImage(store.company?.logo ?? ""))),
                                    ),
                                    Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            roadmap.title,
                                            style: theme.textTheme.bodyText1!.copyWith(
                                                fontSize: 16, color: AppColors.white),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: Text(
                                              roadmap.description,
                                              style: theme.textTheme.bodyText2!.copyWith(
                                                  color: AppColors.white.withOpacity(0.8)),
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            'Created At',
                                            style: theme.textTheme.bodyText2!.copyWith(
                                                color: AppColors.white.withOpacity(0.8)),
                                          ),
                                          Text(
                                            DateFormat('yyyy/MM/dd')
                                                .format(roadmap.createdAt),
                                            style: theme.textTheme.bodyText2!.copyWith(
                                                color: AppColors.white.withOpacity(0.8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
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

  Widget upperSection(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(store.company?.coverImage ?? ""))),
        ),
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        Positioned(
          top: 70,
          right: 1,
          left: 1,
          child: Text(
            store.department?.name ?? "",
            textAlign: TextAlign.center,
            style: theme.textTheme.headline5!.copyWith(color: AppColors.white, fontSize: 40),
          ),
        ),
        Positioned(
          top: 140,
          right: 1,
          left: 1,
          child: Text(
            'A Department in ${store.company?.name}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyText2!.copyWith(color: AppColors.white),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 20,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30), topLeft: Radius.circular(30))),
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 60,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30), topLeft: Radius.circular(30))),
              child: Observer(
                builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (store.department!.isFollowed!.value) {
                              store.unFollowDept();
                            } else {
                              store.followDept();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: Text(
                              store.department!.isFollowed!.value ? 'Following ✔' : 'Follow',
                              style: theme.textTheme.bodyText1!
                                  .copyWith(fontSize: 14, color: AppColors.white),
                            ),
                          )),
                    ],
                  );
                },
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
