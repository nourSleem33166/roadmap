import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:roadmap/app/modules/auth/auth_repo.dart';
import 'package:roadmap/app/shared/dio/factory.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/toasts/loading_toast.dart';
import 'package:roadmap/app/shared/toasts/messages_toasts.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  AuthRepo _authRepo;

  LoginStoreBase(this._authRepo);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final form = FormGroup({
    'email': FormControl<String>(
        value: 'hamza.hazin.learner@gmail.com',
        validators: [Validators.required, Validators.email]),
    'password':
        FormControl<String>(value: '123', validators: [Validators.required]),
  });

  Future<void> login() async {
    try {
      showLoading();
      final res = await _authRepo.login(form.value);
      if (res) Modular.to.pushNamedAndRemoveUntil('/home/', (p0) => false);
    } on AppException catch (e) {
      showToast(e.message);
    } finally {
      closeLoading();
    }
  }

  void goToSignup() {
    Modular.to.pushNamed('/auth/signup/');
  }

  // Future signInWithGoogle(BuildContext context) async {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //             content: WebView(
  //           initialUrl: '${DioFactory.apiUrl}auth/learner/test',
  //           javascriptMode: JavascriptMode.unrestricted,
  //           onWebViewCreated: (WebViewController webViewController) {
  //             _controller.complete(webViewController);
  //           },
  //           onProgress: (int progress) {
  //             print('WebView is loading (progress : $progress%)');
  //           },
  //           javascriptChannels: <JavascriptChannel>{},
  //           navigationDelegate: (NavigationRequest request) {
  //             if (request.url.startsWith('https://www.youtube.com/')) {
  //               print('blocking navigation to $request}');
  //               return NavigationDecision.prevent;
  //             }
  //             print('allowing navigation to $request');
  //             return NavigationDecision.navigate;
  //           },
  //           onPageStarted: (String url) {
  //             print('Page started loading: $url');
  //           },
  //           onPageFinished: (String url) {
  //             print('Page finished loading: $url');
  //           },
  //           gestureNavigationEnabled: true,
  //           backgroundColor: const Color(0x00000000),
  //         ));
  //       });
  // }
}
