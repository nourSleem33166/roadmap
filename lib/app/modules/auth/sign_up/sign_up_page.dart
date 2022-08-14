import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:roadmap/app/modules/auth/sign_up/sign_up_store.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../../../generated/assets.dart';
import '../../../../localizations/locale_keys.g.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ModularState<SignUpPage, SignUpStore> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Sign Up in ',
                          style: theme.textTheme.bodyText2,
                          children: [
                            TextSpan(
                                text: LocaleKeys.app.tr(),
                                style: GoogleFonts.pacifico(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                    color: AppColors.primary))
                          ])),
                  Image.asset(
                    Assets.assetsSignup,
                    height: 100,
                    width: 100,
                  ),
                ],
              ),
              Expanded(
                child: Observer(builder: (context) {
                  return ComponentTemplate(
                    state: store.signUpState,
                    screen: ReactiveForm(
                      formGroup: store.form,
                      child: ReactiveFormConsumer(
                        builder: (context, form, child) {
                          log("form $form");
                          return Stepper(
                              elevation: 0,
                              currentStep: store.currentStep,
                              type: StepperType.vertical,
                              controlsBuilder: (context, details) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      TextButton(
                                          style: theme.textButtonTheme.style,
                                          onPressed: store.currentStep != 0
                                              ? () {
                                                  setState(() {
                                                    details.onStepCancel!();
                                                  });
                                                }
                                              : null,
                                          child: Text('Back',
                                              style: theme.textTheme.bodyText1!.copyWith(
                                                  color: store.currentStep != 0
                                                      ? AppColors.primary
                                                      : Colors.grey,
                                                  fontSize: 15))),
                                      Spacer(),
                                      TextButton(
                                          onPressed: store.checkValidation()
                                              ? () {
                                                  setState(() {
                                                    details.onStepContinue!();
                                                  });
                                                }
                                              : null,
                                          child: Text(
                                              store.currentStep != 2 ? 'Continue' : 'Sign Up',
                                              style: theme.textTheme.bodyText1!.copyWith(
                                                  color: AppColors.primary, fontSize: 15)))
                                    ],
                                  ),
                                );
                              },
                              onStepTapped: (index) => store.changeCurrenStep(index),
                              onStepCancel: () =>
                                  store.changeCurrenStep(store.currentStep - 1),
                              onStepContinue: () {
                                if (store.currentStep == 2)
                                  store.signUp();
                                else
                                  store.changeCurrenStep(store.currentStep + 1);
                              },
                              steps: [
                                Step(
                                    title:
                                        Text('Basic Info', style: theme.textTheme.subtitle1),
                                    content: Column(
                                      children: [
                                        ReactiveTextField(
                                          formControlName: 'firstName',
                                          validationMessages: (control) => {
                                            'required': LocaleKeys.requiredField.tr(),
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'First Name',
                                              alignLabelWithHint: true),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ReactiveTextField(
                                          formControlName: 'lastName',
                                          validationMessages: (control) => {
                                            'required': LocaleKeys.requiredField.tr(),
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Last Name',
                                              alignLabelWithHint: true),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ReactiveTextField(
                                          formControlName: 'email',
                                          validationMessages: (control) => {
                                            'required': LocaleKeys.requiredField.tr(),
                                            'email': 'The email value must be a valid email'
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Email', alignLabelWithHint: true),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ReactiveTextField(
                                          formControlName: 'password',
                                          obscureText: true,
                                          validationMessages: (control) => {
                                            'required': LocaleKeys.requiredField.tr(),
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Password',
                                              alignLabelWithHint: true),
                                        ),
                                      ],
                                    ),
                                    isActive: store.currentStep == 0),
                                Step(
                                  title: Text('Security & Domain',
                                      style: theme.textTheme.subtitle1),
                                  content: Column(
                                    children: [
                                      Text(
                                        'Your Work Domain',
                                        style: theme.textTheme.bodyText1!
                                            .copyWith(color: theme.primaryColor),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Wrap(
                                          children: store.workDomains
                                              .map((domain) => InkWell(
                                                    child: ReactiveFormConsumer(
                                                        builder: (context, form, child) {
                                                      return Chip(
                                                          backgroundColor: form
                                                                      .control('workDomain')
                                                                      .value ==
                                                                  domain
                                                              ? AppColors.primary
                                                              : null,
                                                          label: Text(domain.text,
                                                              style: theme
                                                                  .textTheme.bodyText2!
                                                                  .copyWith(
                                                                      color: form
                                                                                  .control(
                                                                                      'workDomain')
                                                                                  .value ==
                                                                              domain
                                                                          ? AppColors.white
                                                                          : null)));
                                                    }),
                                                    onTap: () {
                                                      store.setWorkDomain(domain);
                                                    },
                                                  ))
                                              .toList(),
                                          spacing: 5),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 100,
                                        child: ReactiveTextField(
                                          expands: true,
                                          formControlName: 'bio',
                                          maxLines: null,
                                          minLines: null,
                                          validationMessages: (control) => {
                                            'required': LocaleKeys.requiredField.tr(),
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Bio', alignLabelWithHint: true),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ReactiveTextField(
                                        formControlName: 'functionalName',
                                        validationMessages: (control) => {
                                          'required': LocaleKeys.requiredField.tr(),
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Functional Name',
                                            alignLabelWithHint: true),
                                      ),
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
                                  isActive: store.currentStep == 1,
                                ),
                                Step(
                                  title: Text('Cover & profile images',
                                      style: theme.textTheme.subtitle1),
                                  content: imagesStep(context),
                                  isActive: store.currentStep == 2,
                                )
                              ]);
                        },
                      ),
                    ),
                  );
                }),
              )
            ]),
      ),
    );
  }

  Widget imagesStep(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: store.coverImage == null
                          ? AssetImage(Assets.assetsCoverImage)
                          : Image.file(store.coverImage!).image)),
            ),
            InkWell(
              onTap: () {
                store.getCoverFile().then((value) {
                  setState(() {
                    log("image is ${store.coverImage?.path}");
                  });
                });

              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        InkWell(
          onTap: () {
            store.getProfileFile().then((value) {
              setState(() {
                log("image is ${store.profileImage?.path}");

              });
            });
          },
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: store.profileImage == null
                        ? Image.asset(Assets.assetsProfile).image
                        : Image.file(
                            store.profileImage!,
                            fit: BoxFit.fill,
                          ).image)),
          ),
        ),
      ],
    );
  }
}
