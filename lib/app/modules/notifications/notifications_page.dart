import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/notifications/notifications_store.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ModularState<NotificationsPage,NotificationsStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text("Roadmap Notifications")],
        ),
      ),
    );
  }
}
