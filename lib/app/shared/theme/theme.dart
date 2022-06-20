import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';

import 'app_colors.dart';
import 'font_styles.dart';

class CustomAppTheme {
  CustomAppTheme._internal();

  static final CustomAppTheme instance = CustomAppTheme._internal();

  String lightThemeID = "light_theme";
  String darkThemeID = "dark_theme";

  /* edit light theme to suit project's design (optional) */
  AppTheme lightTheme() => AppTheme(
      id: lightThemeID,
      description: "Default App Light Theme",
      data: ThemeData.light().copyWith(
          primaryColor: AppColors.primary,
          primaryTextTheme: GoogleFonts.openSansTextTheme(),
          textButtonTheme: TextButtonThemeData(style: ButtonStyle(
            textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return boldStyle(fontSize: 15, color: AppColors.primary);
              else if (states.contains(MaterialState.disabled))
                return regularStyle(fontSize: 15, color: Colors.grey);
              else
                return TextStyle();
            }),
          )),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.grey, width: 1)),
            elevation: MaterialStateProperty.all(4),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColors.primary,
                ),
                borderRadius: BorderRadius.circular(10))),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return AppColors.primary;
              else if (states.contains(MaterialState.disabled))
                return Colors.grey;
              else
                return AppColors.primary;
            }),
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            elevation: MaterialStateProperty.all(4),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return AppColors.primary;
              else if (states.contains(MaterialState.disabled))
                return Colors.grey;
              else
                return AppColors.primary;
            }),
          )),
          accentColor: AppColors.accent,
          inputDecorationTheme: InputDecorationTheme(focusColor: AppColors.primary,focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary,width: 2)),
              alignLabelWithHint: true,
              floatingLabelStyle:
                  regularStyle(fontSize: 15, color: AppColors.primary),
              // focusedBorder: OutlineInputBorder(
              //     borderSide: BorderSide(color: AppColors.primary),
              //     borderRadius: BorderRadius.circular(15)),
              // focusColor: AppColors.primary,
              // disabledBorder: OutlineInputBorder(
              //     borderSide: BorderSide(color: AppColors.primary),
              //     borderRadius: BorderRadius.circular(15)),
              // fillColor: AppColors.primary,
              // enabledBorder: OutlineInputBorder(
              //     borderSide: BorderSide(color: AppColors.primary),
              //     borderRadius: BorderRadius.circular(15)),
              hoverColor: AppColors.primary,
              // border: OutlineInputBorder(
              //     borderSide: BorderSide(color: AppColors.primary),
              //     borderRadius: BorderRadius.circular(15))

          ),
          indicatorColor: AppColors.primary,
          progressIndicatorTheme:
              ProgressIndicatorThemeData(color: AppColors.primary),
          backgroundColor: AppColors.lightPageBackground,
          appBarTheme: AppBarTheme(color: AppColors.primary),
          scaffoldBackgroundColor: AppColors.lightPageBackground,
          textTheme: textTheme(isDark: false)));

  /* edit dark theme to suit project's design (optional) */
  AppTheme darkTheme() => AppTheme(
      id: darkThemeID,
      description: "Default App Dark Theme",
      data: ThemeData.dark().copyWith(
          primaryColor: AppColors.primary,
          accentColor: AppColors.accent,
          backgroundColor: AppColors.darkPageBackground,
          scaffoldBackgroundColor: AppColors.darkPageBackground,
          textTheme: textTheme(isDark: true)));

  TextTheme textTheme({bool isDark = false}) => TextTheme(
        headline1: lightStyle(
            color: isDark ? AppColors.white : AppColors.black, fontSize: 96),
        headline2: lightStyle(
            color: isDark ? AppColors.white : AppColors.black, fontSize: 60),
        headline3: regularStyle(
            color: isDark ? AppColors.white : AppColors.black, fontSize: 48),
        headline4: regularStyle(
            color: isDark ? AppColors.white : AppColors.black, fontSize: 34),
        headline5: boldStyle(
            color: isDark ? AppColors.white : AppColors.black, fontSize: 24),
        headline6: regularStyle(
            color: isDark ? AppColors.white : AppColors.black, fontSize: 20),
        subtitle1: regularStyle(
            color: isDark ? AppColors.white : Colors.black, fontSize: 16),
        subtitle2: regularStyle(
            color: isDark ? Colors.grey : Colors.grey, fontSize: 16),
        bodyText1: boldStyle(
            color: isDark ? AppColors.white : AppColors.black, fontSize: 18),
        bodyText2: regularStyle(
            color: isDark ? AppColors.white : AppColors.black, fontSize: 16),
        caption: lightStyle(
            color: isDark ? AppColors.white : AppColors.black, fontSize: 12),
      );

  /* edit headlineStyle to suit project's design (optional) */
  TextStyle headlineStyle({BuildContext? context, bool? isDark}) {
    isDark = _isDarkMode(context: context, isDark: isDark);
    return TextStyle(
        color: isDark ? AppColors.darkTextColor : AppColors.lightTextColor,
        fontSize: 18);
  }

  /* edit bodyTextStyle to suit project's design (optional) */
  TextStyle bodyTextStyle({BuildContext? context, bool? isDark}) {
    isDark = _isDarkMode(context: context, isDark: isDark);
    return TextStyle(
        color: isDark ? AppColors.darkTextColor : AppColors.lightTextColor,
        fontSize: 16);
  }

  /* edit subtitleTextStyle to suit project's design (optional) */
  TextStyle subtitleTextStyle({BuildContext? context, bool? isDark}) {
    isDark = _isDarkMode(context: context, isDark: isDark);
    return TextStyle(
        color:
            isDark ? AppColors.darkSubtitleColor : AppColors.lightSubtitleColor,
        fontSize: 14);
  }

  bool _isDarkMode({BuildContext? context, bool? isDark}) => context != null
      ? ThemeProvider.controllerOf(context).currentThemeId == darkThemeID
      : isDark ?? false;

  void changeTheme(BuildContext context) =>
      ThemeProvider.controllerOf(context).nextTheme();
}
