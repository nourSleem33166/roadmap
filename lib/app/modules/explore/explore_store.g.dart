// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExploreStore on ExploreStoreBase, Store {
  late final _$selectedExploreAtom =
      Atom(name: 'ExploreStoreBase.selectedExplore', context: context);

  @override
  ExploreType get selectedExplore {
    _$selectedExploreAtom.reportRead();
    return super.selectedExplore;
  }

  @override
  set selectedExplore(ExploreType value) {
    _$selectedExploreAtom.reportWrite(value, super.selectedExplore, () {
      super.selectedExplore = value;
    });
  }

  late final _$pageStateAtom =
      Atom(name: 'ExploreStoreBase.pageState', context: context);

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

  late final _$ExploreStoreBaseActionController =
      ActionController(name: 'ExploreStoreBase', context: context);

  @override
  void changeSelectedExplore(ExploreType value) {
    final _$actionInfo = _$ExploreStoreBaseActionController.startAction(
        name: 'ExploreStoreBase.changeSelectedExplore');
    try {
      return super.changeSelectedExplore(value);
    } finally {
      _$ExploreStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedExplore: ${selectedExplore},
pageState: ${pageState}
    ''';
  }
}
