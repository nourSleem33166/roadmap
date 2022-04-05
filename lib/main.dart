import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import './localizations/codegen_loader.g.dart';
import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() async {
  await preInitializations();
  runApp(EasyLocalization(
      child: ModularApp(module: AppModule(), child: AppWidget()),
      supportedLocales: [Locale("en", ""), Locale("tr", ""), Locale("ar", "")],
      fallbackLocale: Locale("en", ""),
      assetLoader: CodegenLoader(),
      path: "translations"));
}

Future preInitializations() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
}
