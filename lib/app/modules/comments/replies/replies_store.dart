import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart'
    as flutterReactions;
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:roadmap/app/modules/comments/comments_repo.dart';
import 'package:roadmap/app/shared/models/comment_model.dart';
import 'package:roadmap/app/shared/models/interaction.dart';
import 'package:roadmap/app/shared/models/pagination_model.dart';
import 'package:roadmap/app/shared/models/user.dart';
import 'package:roadmap/app/shared/services/storage_service.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../../../generated/assets.dart';

part 'replies_store.g.dart';

class RepliesStore = RepliesStoreBase with _$RepliesStore;

abstract class RepliesStoreBase with Store {
 late CommentsRepo _commentsRepo;
 late Comment _comment;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  ObservableList<Comment> replies = ObservableList<Comment>();
  PaginationModel<Comment>? repliesPagination;

  final PagingController<int, Comment> repliesPagingController =
      PagingController(firstPageKey: 1);

  late String refId;

  User? user;

  FormGroup form = FormGroup({
    'comment': FormControl<String>(
      validators: [Validators.required],
    ),
  });

  @action
  Future initValues(String refId, Comment comment, CommentsRepo repo) async {
    this._commentsRepo = repo;
    this.refId = refId;
    this._comment = comment;
    repliesPagingController.addPageRequestListener((pageKey) {
      getComments(pageKey);
    });

    pageState = ComponentState.FETCHING_DATA;
    user = await SharedPreferencesHelper.getUser();
    pageState = ComponentState.SHOW_DATA;
  }

  Future<void> getComments(int pageKey) async {
    repliesPagination =
        await _commentsRepo.getReplies(pageKey, 10, refId, this._comment.id);

    if (repliesPagination!.currentPage == repliesPagination!.totalPages) {
      repliesPagingController.appendLastPage(repliesPagination!.items);
    } else {
      final nextPageKey = pageKey + 1;
      repliesPagingController.appendPage(repliesPagination!.items, nextPageKey);
    }
  }

  @action
  Future pickImage() async {
    final xfile =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (xfile != null) file = File(xfile.path);
  }

  Future<void> makeInteraction(Comment comment, String type) async {
    final res = await _commentsRepo.makeInteraction(refId, comment.id, type);
  }

  void onReactionChanged(Comment comment, String reaction) {
    runInAction(() {
      comment.interactionValue.value = Interaction(
          id: '',
          commentId: comment.id,
          learnerId: comment.learnerId,
          type: reaction,
          learner: comment.learner);
    });
    makeInteraction(comment, reaction);
  }

  @observable
  File? file;

  @action
  Future sendComment() async {
    FocusManager.instance.primaryFocus?.unfocus();
    repliesPagingController.itemList?.add(Comment(
        id: '',
        parentId: '',
        roadmapId: '',
        text: form.control('comment').value,
        attachment: file != null ? 'nowLoading' : null,
        interactions: [],
        interactionValue: Observable(null),
        learnerId: user!.id,
        learner: Learner(
            id: user!.id,
            firstName: user!.firstName,
            lastName: user!.lastName,
            personalImage: user!.personalImage ?? "")));

    _commentsRepo
        .addReply(form.control('comment').value, refId,_comment.id, file: file)
        .then((value) {
      repliesPagingController.itemList!.last = value;
      repliesPagingController.notifyListeners();
    });
    file = null;
    form.control('comment').value = null;
  }

  Future makeReaction(Comment comment, String type) async {
    _commentsRepo.makeInteraction(refId, comment.id, type);
  }

  final reactionsList = [
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsLike, width: 50, height: 50),
        value: 'Like'),
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsLove, width: 50, height: 50),
        value: 'Love'),
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsHaha, width: 50, height: 50),
        value: 'Haha'),
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsWow, width: 50, height: 50),
        value: 'Wow'),
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsSad, width: 50, height: 50),
        value: 'Sad'),
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsAngry, width: 50, height: 50),
        value: 'Angry')
  ];
}
