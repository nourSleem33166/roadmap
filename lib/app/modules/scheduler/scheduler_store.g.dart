// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduler_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SchedulerStore on SchedulerStoreBase, Store {
  late final _$componentStateAtom =
      Atom(name: 'SchedulerStoreBase.componentState', context: context);

  @override
  ComponentState get componentState {
    _$componentStateAtom.reportRead();
    return super.componentState;
  }

  @override
  set componentState(ComponentState value) {
    _$componentStateAtom.reportWrite(value, super.componentState, () {
      super.componentState = value;
    });
  }

  late final _$initValuesAsyncAction =
      AsyncAction('SchedulerStoreBase.initValues', context: context);

  @override
  Future<dynamic> initValues(
      BuildContext context, EventController<Object?> eventController) {
    return _$initValuesAsyncAction
        .run(() => super.initValues(context, eventController));
  }

  @override
  String toString() {
    return '''
componentState: ${componentState}
    ''';
  }
}
