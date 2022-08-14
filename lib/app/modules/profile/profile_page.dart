import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/profile/profile_store.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../shared/models/user.dart';
import '../../shared/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final store = Modular.get<ProfileStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Observer(builder: (context) {
          return ComponentTemplate(
            state: store.pageState,
            screen: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (store.user != null) userHeader(context, store.user!),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text('Who Am I',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: AppColors.primary,)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text('dsfgldsf;dsfdsfkdsfkdsfdsf;kds;fsd;f',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                tile(context, () {
                  store.goToScheduler();
                }, 'My Scheduler'),
                SizedBox(height: 20),
                tile(context, () {
                  store.goToFollowedCompanies();
                }, 'Followed Companies'),
                SizedBox(height: 20),
                tile(context, () {
                  store.goToFavoriteCompanies();
                }, 'Favorite Companies'),
                SizedBox(height: 20),
                tile(context, () {
                  store.logout();
                }, 'Logout'),

              ],
            ),
          );
        }),
      ),
    );
  }

  Widget userHeader(BuildContext context, User user) {
    user.coverImage =
        "http://c.files.bbci.co.uk/136D7/production/_121257597_mediaitem121257596.jpg";
    user.personalImage =
        "https://yt3.ggpht.com/AAnXC4o1n8BKDsO5l6Uc71rf7WOJjm2-aUHzkvyp9vGYB5F4UtXWTecVzvPOBCFK0bNYsZlD7Hk=s900-c-k-c0x00ffffff-no-rj";
    final theme = Theme.of(context);
    return Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(user.coverImage ?? ""))),
              ),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 1,
                left: 1,
                child: Container(
                  width: 60,
                  height: 60,
                  child: CircleAvatar(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: Image.network(user.personalImage ?? ""))),
                ),
              ),
              Positioned(
                bottom: 40,
                right: 1,
                left: 1,
                child: Text(
                  "${user.firstName} ${user.lastName}",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headline5!.copyWith(color: AppColors.white),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 1,
                left: 1,
                child: Text(
                  user.functionalName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText2!.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tile(BuildContext context, void Function() function, String label) {
    return Card(elevation: 5,
      child: Container(
          height: 60,
          child: Center(
            child: ListTile(
              title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                function();
              },
              trailing: Transform.rotate(
                  angle: math.pi,
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black,
                  )),
            ),
          )),
    );
  }
}
