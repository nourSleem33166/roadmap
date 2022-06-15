// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  late final _$currentDrawerIndexAtom =
      Atom(name: 'HomeStoreBase.currentDrawerIndex', context: context);

  @override
  int get currentDrawerIndex {
    _$currentDrawerIndexAtom.reportRead();
    return super.currentDrawerIndex;
  }

  @override
  set currentDrawerIndex(int value) {
    _$currentDrawerIndexAtom.reportWrite(value, super.currentDrawerIndex, () {
      super.currentDrawerIndex = value;
    });
  }

  late final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase', context: context);

  @override
  void handleNavigation(int i) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.handleNavigation');
    try {
      return super.handleNavigation(i);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentDrawerIndex: ${currentDrawerIndex}
    ''';
  }
}
