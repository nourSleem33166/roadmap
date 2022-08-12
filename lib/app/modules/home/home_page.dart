import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'home_store.dart';

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
      appBar: PreferredSize(
          child: SizedBox(
            height: 30,
          ),
          preferredSize: Size.fromHeight(30)),
      bottomNavigationBar: Observer(builder: (context) {
        return SalomonBottomBar(
          currentIndex: store.currentDrawerIndex,
          onTap: (i) => store.handleNavigation(i),
          items: [
            /// Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile",style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.teal
              )),
              selectedColor: Colors.teal,
            ),

            /// Home
            SalomonBottomBarItem(
              icon: Icon(Icons.explore,),
              title: Text("Explore",style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: theme.primaryColor
              )),
              selectedColor: theme.primaryColor,
            ),
          ],
          itemPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        );
      }),
    );
  }
}
