// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CommentsStore on CommentsStoreBase, Store {
  late final _$pageStateAtom =
      Atom(name: 'CommentsStoreBase.pageState', context: context);

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

  late final _$fileAtom =
      Atom(name: 'CommentsStoreBase.file', context: context);

  @override
  File? get file {
    _$fileAtom.reportRead();
    return super.file;
  }

  @override
  set file(File? value) {
    _$fileAtom.reportWrite(value, super.file, () {
      super.file = value;
    });
  }

  late final _$initValuesAsyncAction =
      AsyncAction('CommentsStoreBase.initValues', context: context);

  @override
  Future<dynamic> initValues(String refId, CommentsRepo repo) {
    return _$initValuesAsyncAction.run(() => super.initValues(refId, repo));
  }

  late final _$pickImageAsyncAction =
      AsyncAction('CommentsStoreBase.pickImage', context: context);

  @override
  Future<dynamic> pickImage() {
    return _$pickImageAsyncAction.run(() => super.pickImage());
  }

  late final _$sendCommentAsyncAction =
      AsyncAction('CommentsStoreBase.sendComment', context: context);

  @override
  Future<dynamic> sendComment() {
    return _$sendCommentAsyncAction.run(() => super.sendComment());
  }

  @override
  String toString() {
    return '''
pageState: ${pageState},
file: ${file}
    ''';
  }
}
