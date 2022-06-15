// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CompanyStore on CompanyStoreBase, Store {
  late final _$pageStateAtom =
      Atom(name: 'CompanyStoreBase.pageState', context: context);

  @override
  ComponentState get pageState {
    _$pageStateAtom.reportRead();
    return super.pageState;
  }

  @override
  set pageState(ComponentState value) {
    _$pageStateAtom.reportWrite(value, super.pageState, () {
      super.pageState = value;
    });
  }

  late final _$selectedViewIndexAtom =
      Atom(name: 'CompanyStoreBase.selectedViewIndex', context: context);

  @override
  int get selectedViewIndex {
    _$selectedViewIndexAtom.reportRead();
    return super.selectedViewIndex;
  }

  @override
  set selectedViewIndex(int value) {
    _$selectedViewIndexAtom.reportWrite(value, super.selectedViewIndex, () {
      super.selectedViewIndex = value;
    });
  }

  late final _$getDataAsyncAction =
      AsyncAction('CompanyStoreBase.getData', context: context);

  @override
  Future<void> getData(String companyId) {
    return _$getDataAsyncAction.run(() => super.getData(companyId));
  }

  late final _$CompanyStoreBaseActionController =
      ActionController(name: 'CompanyStoreBase', context: context);

  @override
  void changeIndex(int index) {
    final _$actionInfo = _$CompanyStoreBaseActionController.startAction(
        name: 'CompanyStoreBase.changeIndex');
    try {
      return super.changeIndex(index);
    } finally {
      _$CompanyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
selectedViewIndex: ${selectedViewIndex}
    ''';
  }
}
