import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:roadmap/app/modules/auth/login/login_store.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';
import 'package:roadmap/localizations/locale_keys.g.dart';

import '../../../../generated/assets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginStore>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    Timer(Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ReactiveForm(
                formGroup: store.form,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SlideTransition(
                                position: Tween<Offset>(
                                        begin: Offset(0, -1), end: Offset.zero)
                                    .animate(_controller),
                                child: Column(
                                  children: [
                                    SizedBox(height: 50),
                                    SvgPicture.asset(Assets.assetsSignIn,
                                        height: 200),
                                    SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Text('Login',
                                            style: theme.textTheme.bodyText2!
                                                .copyWith(
                                                    color: AppColors.primary,
                                                    fontSize: 40)),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    ReactiveTextField(
                                      formControlName: 'email',
                                      validationMessages: (control) => {
                                        'required':
                                            LocaleKeys.requiredField.tr(),
                                        'email':
                                            'The email value must be a valid email'
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'Email',
                                          alignLabelWithHint: true),
                                    ),
                                    SizedBox(height: 20),
                                    ReactiveTextField(
                                      validationMessages: (control) => {
                                        'required':
                                            LocaleKeys.requiredField.tr(),
                                      },
                                      formControlName: 'password',
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          labelText: 'Password',
                                          alignLabelWithHint: true),
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SlideTransition(
                        position:
                            Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
                                .animate(_controller),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  child: Builder(builder: (context) {
                                    return ElevatedButton(
                                        onPressed:
                                            ReactiveForm.of(context)!.valid
                                                ? store.login
                                                : null,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Login',
                                            style: theme.textTheme.bodyText1!
                                                .copyWith(
                                                    color: AppColors.white),
                                          ),
                                        ));
                                  }),
                                ),
                                SizedBox(width: 30),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: store.goToSignup,
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: RichText(
                              text: TextSpan(
                                  text: 'Don\'t have an account ? ',
                                  style: theme.textTheme.subtitle2,
                                  children: [
                                    TextSpan(
                                        text: 'Sign up',
                                        style: theme.textTheme.bodyText1!
                                            .copyWith(color: AppColors.primary))
                                  ]),
                            )),
                      ),
                    ]))));
  }
}
