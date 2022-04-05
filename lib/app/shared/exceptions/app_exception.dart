import '../../../localizations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class AppException implements Exception {
  final String message;
  final Exception? innerException;

  AppException({required this.message, this.innerException});

  factory AppException.unknown() =>
      AppException(message: LocaleKeys.unKnownError.tr());

  @override
  String toString() {
    return 'AppException{message: $message, innerException: $innerException}';
  }
}
