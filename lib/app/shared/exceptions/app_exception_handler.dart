import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../localizations/locale_keys.g.dart';
import 'app_exception.dart';


class AppExceptionHandler {
  AppExceptionHandler._internal();

  static AppExceptionHandler instance = AppExceptionHandler._internal();

  AppException handleError(error) {
    if (error is SocketException) {
      return _handleSocketException(error);
    } else if (error is FormatException)
      return _handleFormatException(error);
    else if (error is DioError)
      return _handleDioError(error);
    // else if (error is FirebaseAuthException)
    //   return _firebaseAuthExceptionsHandler(error, error.stackTrace);
    else
      return AppException(
        message: LocaleKeys.unKnownError.tr(),
        innerException: error,
      );
  }

  AppException _handleSocketException(SocketException socketException) {
    return AppException(
        message: LocaleKeys.noInternetConnection.tr(),
        innerException: socketException);
  }

  AppException _handleFormatException(FormatException formatException) {
    return AppException(
        message: LocaleKeys.formatException.tr(),
        innerException: formatException);
  }

  AppException _handleDioError(DioError error) {
    if (error.error == "XMLHttpRequest error.")
      return AppException(
        message: LocaleKeys.noInternetConnection.tr(),
        innerException: error,
      );
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return AppException(
          message: LocaleKeys.dioError_connectTimeout.tr(),
          innerException: error,
        );
      case DioErrorType.response:
        return _responseErrorHandler(error);
      case DioErrorType.receiveTimeout:
        return AppException(
          message: LocaleKeys.dioError_receiveTimeout.tr(),
          innerException: error,
        );
      case DioErrorType.sendTimeout:
        return AppException(
          message: LocaleKeys.dioError_sendTimeout.tr(),
          innerException: error,
        );
      case DioErrorType.cancel:
        return AppException(
          message: LocaleKeys.dioError_requestCancelled.tr(),
          innerException: error,
        );
      case DioErrorType.other:
      default:
        return AppException(
          message: LocaleKeys.unKnownError.tr(),
          innerException: error,
        );
    }
  }

  AppException _responseErrorHandler(DioError error) {
    switch (error.response?.statusCode) {
      case 400:
        return AppException(
          message: LocaleKeys.dioError_badRequest.tr(),
          innerException: error,
        );
      case 404:
        return AppException(
          message: LocaleKeys.notFound.tr(),
          innerException: error,
        );
      case 401:
      case 403:
        return AppException(
          message: LocaleKeys.dioError_Unauthorized.tr(),
          innerException: error,
        );
      case 500:
        return AppException(
          message: LocaleKeys.dioError_internalServerError.tr(),
          innerException: error,
        );
      default:
        return AppException(
          message: LocaleKeys.unKnownError.tr(),
          innerException: error,
        );
    }
  }

  // AppException _firebaseAuthExceptionsHandler(
  //     FirebaseAuthException exception, StackTrace? stack) {
  //   switch (exception.code) {
  //     case 'expired-action-code':
  //       return AppException(
  //         message: LocaleKeys.firebaseError_expiredActionCode.tr(),
  //         innerException: exception,
  //       );
  //     case 'invalid-action-code':
  //       return AppException(
  //         message: LocaleKeys.firebaseError_invalidActionCode.tr(),
  //         innerException: exception,
  //       );
  //     case 'user-disabled':
  //       return AppException(
  //         message: LocaleKeys.firebaseError_userDisabled.tr(),
  //         innerException: exception,
  //       );
  //     case 'user-not-found':
  //       return AppException(
  //         message: LocaleKeys.firebaseError_userNotFound.tr(),
  //         innerException: exception,
  //       );
  //     case 'weak-password':
  //       return AppException(
  //         message: LocaleKeys.firebaseError_weakPassword.tr(),
  //         innerException: exception,
  //       );
  //     case 'wrong-password':
  //       return AppException(
  //         message: LocaleKeys.firebaseError_wrongPassword.tr(),
  //         innerException: exception,
  //       );
  //     case 'email-already-in-use':
  //       return AppException(
  //         message: LocaleKeys.firebaseError_emailAlreadyInUse.tr(),
  //         innerException: exception,
  //       );
  //     case 'network-request-failed':
  //       return AppException(
  //         message: LocaleKeys.noInternetConnection.tr(),
  //         innerException: exception,
  //       );
  //     case 'invalid-email':
  //       return AppException(
  //         message: LocaleKeys.invalidEmail.tr(),
  //         innerException: exception,
  //       );
  //     case 'operation-not-allowed':
  //       return AppException(
  //         message: LocaleKeys.firebaseError_operationNotAllowed.tr(),
  //         innerException: exception,
  //       );
  //     default:
  //       FirebaseCrashlytics.instance.recordError(exception, stack);
  //       return AppException(
  //         message: LocaleKeys.unKnownError.tr(),
  //         innerException: exception,
  //       );
  //   }
  // }
}
