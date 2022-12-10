import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/shared/services/notification_service.dart';

import './localizations/codegen_loader.g.dart';
import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() async {
  await preInitializations();
  runApp(EasyLocalization(
      child: ModularApp(module: AppModule(), child: AppWidget()),
      supportedLocales: [Locale("en", "")],
      fallbackLocale: Locale("en", ""),
      assetLoader: CodegenLoader(),
      path: "translations"));
}

Future preInitializations() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await NotificationService.instance.init();

  // await SharedPreferencesHelper.deleteUser();
}

