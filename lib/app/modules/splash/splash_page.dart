import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/shared/services/storage_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((value) async {
      final user = await SharedPreferencesHelper.getUser();
      if (user != null)
        Modular.to.pushReplacementNamed('/home/');
      else
        Modular.to.pushReplacementNamed('/auth/');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'RoadMap',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                fontSize: 45, letterSpacing: 8, color: theme.primaryColor),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please Be Patient',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontSize: 16, color: theme.primaryColor),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                  width: 20, height: 20, child: CircularProgressIndicator())
            ],
          )
        ],
      )),
    );
  }
}
