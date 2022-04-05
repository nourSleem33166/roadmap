import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:roadmap/app/modules/auth/auth_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/work_domain.dart';
import 'package:roadmap/app/shared/toasts/loading_toast.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../../shared/toasts/messages_toasts.dart';

part 'sign_up_store.g.dart';

class SignUpStore = SignUpStoreBase with _$SignUpStore;

abstract class SignUpStoreBase with Store {
  AuthRepo _authRepo;

  FormGroup form = FormGroup({
    'firstName': FormControl<String>(value: 'Nour',validators: [Validators.required]),
    'lastName': FormControl<String>(value: 'Sleem',validators: [Validators.required]),
    'email': FormControl<String>(value: 'Nour33166da1dda1@gmail.com',
        validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(value: '12345678',
        validators: [Validators.required, Validators.minLength(4)]),
    'workDomain': FormControl<WorkDomain>(validators: [Validators.required]),
    'bio': FormControl<String>(value: 'Sorry',
        validators: [Validators.required]),
    'functionalName': FormControl<String>(
        value: 'Mobile Developer',
        validators: [Validators.required]),
  });

  SignUpStoreBase(this._authRepo) {
    getDomains().then((value) {
      workDomains = value;
    });
  }

  @observable
  ComponentState signUpState = ComponentState.FETCHING_DATA;

  @observable
  int currentStep = 0;

  List<WorkDomain> workDomains = [];

  @action
  setWorkDomain(WorkDomain domain) {
    if (domain != form.control('workDomain').value)
      form.control('workDomain').value = domain;
    else
      form.control('workDomain').value = null;
  }

  @action
  void changeCurrenStep(int value) {
    currentStep = value;
  }

  @action
  Future<List<WorkDomain>> getDomains() async {
    try {
      final res = await _authRepo.getDomains();
      signUpState = ComponentState.SHOW_DATA;
      return res;
    } on AppException catch (e) {
      showErrorToast(e.message);
      return [];
    }
  }

  Future<void> signUp() async {
    try {
      showLoading();
      final userSignedUp = await _authRepo.signup(form.value);
      if (userSignedUp) {
        Modular.to.pushReplacementNamed('/home/');
      }
    } on AppException catch (e) {
      showToast(e.message);
    } finally {
      closeLoading();
    }
  }
}
