import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roadmap/generated/assets.dart';

import '../../../localizations/locale_keys.g.dart';
import '../../shared/theme/app_colors.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Spacer(flex: 2),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(Assets.assetsWelcome, height: 200),
          SizedBox(
            height: 10,
          ),
          Text(LocaleKeys.app.tr(),
              style: GoogleFonts.pacifico(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: AppColors.primary)),
          SizedBox(height: 5),
          Text(
            'Learn something new everyday..',
            style: theme.textTheme.subtitle2,
          )
        ]),
        Spacer(
          flex: 2,
        ),
        Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    Modular.to.pushNamed('/auth/signup');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Get Started',
                      style: theme.textTheme.bodyText1!
                          .copyWith(color: AppColors.white, fontSize: 16),
                    ),
                  )),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      elevation: 0),
                  onPressed: () {
                    Modular.to.pushNamed('/auth/signin');

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('Already Have An Account',
                        style: theme.textTheme.bodyText2!
                            .copyWith(color: AppColors.primary)),
                  )),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ),
        Spacer(),
      ],
    )));
  }
}
