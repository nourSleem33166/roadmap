import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
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
    'firstName': FormControl<String>(validators: [Validators.required]),
    'lastName': FormControl<String>(validators: [Validators.required]),
    'email': FormControl<String>(validators: [Validators.required, Validators.email]),
    'password':
        FormControl<String>(validators: [Validators.required, Validators.minLength(4)]),
    'workDomain': FormControl<WorkDomain>(validators: [Validators.required]),
    'bio': FormControl<String>(validators: [Validators.required]),
    'functionalName': FormControl<String>(validators: [Validators.required]),
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

  bool _firstStepValid() {
    return form.control('firstName').valid &&
        form.control('lastName').valid &&
        form.control('email').valid &&
        form.control('password').valid;
  }

  bool _secondStepValid() {
    return form.control('workDomain').valid;
  }

  bool checkValidation() {
    if (currentStep == 0)
      return _firstStepValid();
    else if (currentStep == 1) return _secondStepValid();
    return true;
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
        Modular.to.pushNamedAndRemoveUntil('/home/', (p0) => false);
      }
    } on AppException catch (e) {
      showToast(e.message);
    } finally {
      closeLoading();
    }
  }

  Future<File?> getImage() async {
    final file = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return File(file.path);
    }
  }

  @action
  Future getCoverFile() async {
    coverImage = await getImage();
  }

  @action
  Future getProfileFile() async {
    profileImage = await getImage();
  }

  @observable
  File? profileImage;
  @observable
  File? coverImage;
}
