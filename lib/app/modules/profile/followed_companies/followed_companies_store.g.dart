// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'followed_companies_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FollowedCompaniesStore on FollowedCompaniesStoreBase, Store {
  late final _$pageStateAtom =
      Atom(name: 'FollowedCompaniesStoreBase.pageState', context: context);

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

  late final _$initValuesAsyncAction =
      AsyncAction('FollowedCompaniesStoreBase.initValues', context: context);

  @override
  Future<dynamic> initValues() {
    return _$initValuesAsyncAction.run(() => super.initValues());
  }

  @override
  String toString() {
    return '''
pageState: ${pageState}
    ''';
  }
}
