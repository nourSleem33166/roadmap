// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeptStore on DeptStoreBase, Store {
  late final _$pageStateAtom =
      Atom(name: 'DeptStoreBase.pageState', context: context);

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
      Atom(name: 'DeptStoreBase.selectedViewIndex', context: context);

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
      AsyncAction('DeptStoreBase.getData', context: context);

  @override
  Future<void> getData() {
    return _$getDataAsyncAction.run(() => super.getData());
  }

  late final _$DeptStoreBaseActionController =
      ActionController(name: 'DeptStoreBase', context: context);

  @override
  void changeIndex(int index) {
    final _$actionInfo = _$DeptStoreBaseActionController.startAction(
        name: 'DeptStoreBase.changeIndex');
    try {
      return super.changeIndex(index);
    } finally {
      _$DeptStoreBaseActionController.endAction(_$actionInfo);
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
