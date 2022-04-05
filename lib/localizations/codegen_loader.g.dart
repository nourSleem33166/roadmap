// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ar = {
  "app": "Roadmap",
  "emptyData": "لا يوجد بيانات",
  "retry": "إعادة المحاولة",
  "unKnownError": "حدث خطأ ما",
  "requiredField": "This field is required"
};
static const Map<String,dynamic> tr = {
  "app": "Roadmap",
  "emptyData": "veri yok",
  "retry": "yeniden denemek",
  "unKnownError": "bir şeyler yanlış gitti",
  "requiredField": "This field is required"
};
static const Map<String,dynamic> en = {
  "app": "Roadmap",
  "emptyData": "No Data",
  "retry": "Retry",
  "unKnownError": "Something went wrong",
  "requiredField": "This field is required"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "tr": tr, "en": en};
}
