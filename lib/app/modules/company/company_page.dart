import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/company/company_store.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../shared/theme/app_colors.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends ModularState<CompanyPage, CompanyStore> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Center(
          child: Observer(builder: (context) {
            return ComponentTemplate(
              state: store.pageState,
              onRetry: () => store.getData(store.companyId),
              screen: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  upperSection(context),
                  Expanded(
                      child: SingleChildScrollView(
                    child: store.selectedViewIndex == 0
                        ? _buildAbout(context)
                        : _buildDepts(context),
                  ))
                ],
              ),
            );
          }),
        ),
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
                'Who Are We',
                style: theme.textTheme.headline5!
                    .copyWith(color: theme.primaryColor, fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            store.company?.about ?? "",
            style: theme.textTheme.bodyText2,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Basic Info',
                style: theme.textTheme.headline5!
                    .copyWith(color: theme.primaryColor, fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                child: Column(children: [
                  _buildInfoItem(
                    context,
                    'Our Website',
                    store.company?.website ?? "",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildInfoItem(
                      context, 'Our Email', store.company?.email ?? "Meta@facebook.com"),
                  SizedBox(
                    height: 20,
                  ),
                  _buildInfoItem(context, 'Our Staff',
                      store.company?.numOfEmployees?.toString() ?? 10.toString()),
                  SizedBox(
                    height: 20,
                  ),
                  _buildInfoItem(context, 'Timezone',
                      (store.company?.timeZone?.toString() ?? 10.toString())),
                  SizedBox(
                    height: 20,
                  ),
                  _buildInfoItem(context, "Work Hours",
                      (store.company?.workHours?.toString() ?? 10.toString())),
                ]),
              ),
            ),
          ),
          SizedBox(height: 10)
        ]));
  }

  Widget _buildDepts(BuildContext context) {

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Our Departments',
                style: theme.textTheme.headline5!
                    .copyWith(color: theme.primaryColor, fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              children: store.departments
                  .map((dept) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            store.goToDeptDetails(dept);
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              child: Container(
                                  width: 150,
                                  height: 200,
                                  child: Stack(children: [
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
                                                dept.name,
                                                style: theme.textTheme.bodyText1!.copyWith(
                                                    fontSize: 16, color: AppColors.white),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Flexible(
                                                  child: Text(dept.description,
                                                      style: theme.textTheme.bodyText2!
                                                          .copyWith(
                                                        overflow: TextOverflow.ellipsis,
                                                              color: AppColors.white
                                                                  .withOpacity(0.8))))
                                            ]))
                                  ]))))))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String title, String text) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 120,
          child: Text(
            title + ": ",
            style:
                theme.textTheme.bodyText2!.copyWith(fontSize: 16, color: theme.primaryColor),
          ),
        ),
        Text(
          text,
          style: theme.textTheme.bodyText2!.copyWith(
            fontSize: 16,
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
            store.company?.name ?? "",
            textAlign: TextAlign.center,
            style: theme.textTheme.headline5!.copyWith(color: AppColors.white),
          ),
        ),
        Positioned(
          top: 140,
          right: 1,
          left: 1,
          child: Text(
            'Software Company',
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
              width: MediaQuery.of(context).size.width / 2,
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
                      InkWell(
                        child: Container(
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, color: AppColors.white),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: IconButton(
                                    icon: Icon(
                                        store.company!.isFavorite!.value
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: theme.primaryColor,
                                        size: 35),
                                    onPressed: () {
                                      if (store.company!.isFavorite!.value) {
                                        store.removeCompanyFromFavs();
                                      } else {
                                        store.addCompanyToFavs();
                                      }
                                    }),
                              ),
                            )),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (store.company!.isFollowed!.value) {
                              store.unFollowCompany();
                            } else {
                              store.followCompany();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: Text(
                              store.company!.isFollowed!.value ? 'Following ✔' : 'Follow',
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
        Positioned(
            right: 5,
            child: Container(
                width: 60,
                height: 60,
                child: IconButton(
                    icon: Icon(Icons.report_sharp, color: AppColors.white, size: 25),
                    onPressed: () {
                      store.reportCompany(context, store.companyId);
                    }))),
        Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => store.changeIndex(0),
                      child: Column(
                        children: [
                          Text('About',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyText1!
                                  .copyWith(color: AppColors.white, fontSize: 16)),
                          Divider(
                            thickness: 2,
                            color: store.selectedViewIndex == 0
                                ? AppColors.white
                                : Colors.transparent,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => store.changeIndex(1),
                      child: Column(
                        children: [
                          Text('Departments',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyText1!
                                  .copyWith(color: AppColors.white, fontSize: 16)),
                          Divider(
                            thickness: 2,
                            color: store.selectedViewIndex == 1
                                ? AppColors.white
                                : Colors.transparent,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
