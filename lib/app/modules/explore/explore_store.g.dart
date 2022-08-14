// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExploreStore on ExploreStoreBase, Store {
  late final _$componentStateAtom =
      Atom(name: 'ExploreStoreBase.componentState', context: context);

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

  late final _$isLoadingAtom =
      Atom(name: 'ExploreStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isCompanyLoadingAtom =
      Atom(name: 'ExploreStoreBase.isCompanyLoading', context: context);

  @override
  bool get isCompanyLoading {
    _$isCompanyLoadingAtom.reportRead();
    return super.isCompanyLoading;
  }

  @override
  set isCompanyLoading(bool value) {
    _$isCompanyLoadingAtom.reportWrite(value, super.isCompanyLoading, () {
      super.isCompanyLoading = value;
    });
  }

  late final _$isRoadmapsSearchViewAtom =
      Atom(name: 'ExploreStoreBase.isRoadmapsSearchView', context: context);

  @override
  bool get isRoadmapsSearchView {
    _$isRoadmapsSearchViewAtom.reportRead();
    return super.isRoadmapsSearchView;
  }

  @override
  set isRoadmapsSearchView(bool value) {
    _$isRoadmapsSearchViewAtom.reportWrite(value, super.isRoadmapsSearchView,
        () {
      super.isRoadmapsSearchView = value;
    });
  }

  late final _$isCompaniesSearchViewAtom =
      Atom(name: 'ExploreStoreBase.isCompaniesSearchView', context: context);

  @override
  bool get isCompaniesSearchView {
    _$isCompaniesSearchViewAtom.reportRead();
    return super.isCompaniesSearchView;
  }

  @override
  set isCompaniesSearchView(bool value) {
    _$isCompaniesSearchViewAtom.reportWrite(value, super.isCompaniesSearchView,
        () {
      super.isCompaniesSearchView = value;
    });
  }

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

  late final _$getRoadmapsAsyncAction =
      AsyncAction('ExploreStoreBase.getRoadmaps', context: context);

  @override
  Future<void> getRoadmaps(int pageKey) {
    return _$getRoadmapsAsyncAction.run(() => super.getRoadmaps(pageKey));
  }

  late final _$searchRoadmapsAsyncAction =
      AsyncAction('ExploreStoreBase.searchRoadmaps', context: context);

  @override
  Future<void> searchRoadmaps(int pageKey, [String? text]) {
    return _$searchRoadmapsAsyncAction
        .run(() => super.searchRoadmaps(pageKey, text));
  }

  late final _$getCompaniesAsyncAction =
      AsyncAction('ExploreStoreBase.getCompanies', context: context);

  @override
  Future<void> getCompanies(int pageKey, [String? text]) {
    return _$getCompaniesAsyncAction
        .run(() => super.getCompanies(pageKey, text));
  }

  late final _$searchCompaniesAsyncAction =
      AsyncAction('ExploreStoreBase.searchCompanies', context: context);

  @override
  Future<void> searchCompanies(int pageKey, [String? text]) {
    return _$searchCompaniesAsyncAction
        .run(() => super.searchCompanies(pageKey, text));
  }

  late final _$roadmapsPaginationAsyncAction =
      AsyncAction('ExploreStoreBase.roadmapsPagination', context: context);

  @override
  Future<dynamic> roadmapsPagination() {
    return _$roadmapsPaginationAsyncAction
        .run(() => super.roadmapsPagination());
  }

  late final _$searchedRoadmapsPaginationAsyncAction = AsyncAction(
      'ExploreStoreBase.searchedRoadmapsPagination',
      context: context);

  @override
  Future<dynamic> searchedRoadmapsPagination() {
    return _$searchedRoadmapsPaginationAsyncAction
        .run(() => super.searchedRoadmapsPagination());
  }

  late final _$searchedCompaniesPaginationAsyncAction = AsyncAction(
      'ExploreStoreBase.searchedCompaniesPagination',
      context: context);

  @override
  Future<dynamic> searchedCompaniesPagination() {
    return _$searchedCompaniesPaginationAsyncAction
        .run(() => super.searchedCompaniesPagination());
  }

  late final _$companiesPaginationAsyncAction =
      AsyncAction('ExploreStoreBase.companiesPagination', context: context);

  @override
  Future<dynamic> companiesPagination() {
    return _$companiesPaginationAsyncAction
        .run(() => super.companiesPagination());
  }

  late final _$onQueryChangedAsyncAction =
      AsyncAction('ExploreStoreBase.onQueryChanged', context: context);

  @override
  Future<dynamic> onQueryChanged(String? query) {
    return _$onQueryChangedAsyncAction.run(() => super.onQueryChanged(query));
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
componentState: ${componentState},
isLoading: ${isLoading},
isCompanyLoading: ${isCompanyLoading},
isRoadmapsSearchView: ${isRoadmapsSearchView},
isCompaniesSearchView: ${isCompaniesSearchView},
selectedExplore: ${selectedExplore}
    ''';
  }
}
