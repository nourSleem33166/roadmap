// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignUpStore on SignUpStoreBase, Store {
  late final _$signUpStateAtom =
      Atom(name: 'SignUpStoreBase.signUpState', context: context);

  @override
  ComponentState get signUpState {
    _$signUpStateAtom.reportRead();
    return super.signUpState;
  }

  @override
  set signUpState(ComponentState value) {
    _$signUpStateAtom.reportWrite(value, super.signUpState, () {
      super.signUpState = value;
    });
  }

  late final _$currentStepAtom =
      Atom(name: 'SignUpStoreBase.currentStep', context: context);

  @override
  int get currentStep {
    _$currentStepAtom.reportRead();
    return super.currentStep;
  }

  @override
  set currentStep(int value) {
    _$currentStepAtom.reportWrite(value, super.currentStep, () {
      super.currentStep = value;
    });
  }

  late final _$getDomainsAsyncAction =
      AsyncAction('SignUpStoreBase.getDomains', context: context);

  @override
  Future<List<WorkDomain>> getDomains() {
    return _$getDomainsAsyncAction.run(() => super.getDomains());
  }

  late final _$SignUpStoreBaseActionController =
      ActionController(name: 'SignUpStoreBase', context: context);

  @override
  dynamic setWorkDomain(WorkDomain domain) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.setWorkDomain');
    try {
      return super.setWorkDomain(domain);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeCurrenStep(int value) {
    final _$actionInfo = _$SignUpStoreBaseActionController.startAction(
        name: 'SignUpStoreBase.changeCurrenStep');
    try {
      return super.changeCurrenStep(value);
    } finally {
      _$SignUpStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
signUpState: ${signUpState},
currentStep: ${currentStep}
    ''';
  }
}
