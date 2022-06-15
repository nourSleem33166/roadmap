import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadmap/app/modules/explore/explore_store.dart';

import '../../../localizations/locale_keys.g.dart';
import '../../shared/theme/app_colors.dart';
import 'home_store.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: RouterOutlet(),
        appBar: PreferredSize(child: SizedBox(height: 30,),preferredSize: Size.fromHeight(30)),
        bottomNavigationBar:
        Observer(
          builder: (context) {
            return SalomonBottomBar(
              currentIndex: store.currentDrawerIndex,
              onTap: (i) => store.handleNavigation(i),
              items: [

                /// Profile
                SalomonBottomBarItem(
                  icon: Icon(Icons.person),
                  title: Text("Profile"),
                  selectedColor: Colors.teal,
                ),
                /// Home
                SalomonBottomBarItem(
                  icon: Icon(Icons.explore),
                  title: Text("Explore"),
                  selectedColor: theme.primaryColor,
                ),


                SalomonBottomBarItem(
                  icon: Icon(FontAwesomeIcons.solidBell),
                  title: Text("Notification"),
                  selectedColor: Colors.redAccent,
                ),
              ],itemPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            );
          }
        ),

      );
  }
}
