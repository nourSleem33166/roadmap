import 'package:bot_toast/bot_toast.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

import './shared/theme/theme.dart';

// ignore: must_be_immutable
class AppWidget extends StatelessWidget {
  final botToastBuilder = BotToastInit();

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) => ThemeProvider(
            saveThemesOnChange: true,
            themes: [
              CustomAppTheme.instance.lightTheme(),
              CustomAppTheme.instance.darkTheme()
            ],
            onInitCallback: (controller, previouslySavedThemeFuture) async {
              String? savedTheme = await previouslySavedThemeFuture;
              if (savedTheme != null) {
                controller.setTheme(savedTheme);
              } else {
                Brightness platformBrightness =
                    SchedulerBinding.instance.window.platformBrightness;
                if (platformBrightness == Brightness.dark)
                  controller.setTheme(CustomAppTheme.instance.darkThemeID);
                else
                  controller.setTheme(CustomAppTheme.instance.lightThemeID);
                controller.forgetSavedTheme();
              }
            },
            child: ThemeConsumer(
                child: Builder(
                    builder: (themeContext) => MaterialApp.router(
                        routerDelegate: Modular.routerDelegate,
                        routeInformationParser: Modular.routeInformationParser,
                        title: "Roadmap",
                        debugShowCheckedModeBanner: false,
                        builder: (context, child) {
                          child = botToastBuilder(context, child);
                          return child;
                        },
                        localizationsDelegates: context.localizationDelegates,
                        supportedLocales: context.supportedLocales,
                        locale: context.locale,
                        color: AppColors.primary,
                        theme: ThemeProvider.themeOf(themeContext).data)))));
  }
}
