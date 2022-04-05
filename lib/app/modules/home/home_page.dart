import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/shared/theme/theme.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () =>
                    CustomAppTheme.instance.changeTheme(context),
                child: Text("Change Theme")),
          ],
        ),
      ),
    );
  }
}
