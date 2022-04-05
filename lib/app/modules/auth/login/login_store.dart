import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:roadmap/app/modules/auth/auth_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/toasts/loading_toast.dart';
import 'package:roadmap/app/shared/toasts/messages_toasts.dart';

part 'login_store.g.dart';

class LoginStore = LoginStoreBase with _$LoginStore;

abstract class LoginStoreBase with Store {
  AuthRepo _authRepo;

  LoginStoreBase(this._authRepo);

  final form = FormGroup({
    'email': FormControl<String>(
        value: 'testEmail@gmail.com',
        validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(value: '123456',
        validators: [Validators.required]),
  });

  Future<void> login() async {
    try {
      showLoading();
      final res = await _authRepo.login(form.value);
      if(res) Modular.to.pushReplacementNamed('/home/');
    } on AppException catch (e) {
      showToast(e.message);
    } finally {
      closeLoading();
    }
  }

  void goToSignup() {
    Modular.to.pushNamed('/auth/signup/');
  }
}
