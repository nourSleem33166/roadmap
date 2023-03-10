import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart' as flutterReactions;
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mobx/mobx.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:roadmap/app/modules/comments/comments_repo.dart';
import 'package:roadmap/app/modules/comments/replies/replies_page.dart';
import 'package:roadmap/app/shared/models/comment_model.dart';
import 'package:roadmap/app/shared/models/interaction.dart';
import 'package:roadmap/app/shared/models/pagination_model.dart';
import 'package:roadmap/app/shared/models/user.dart';
import 'package:roadmap/app/shared/services/storage_service.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';
import 'package:sizer/sizer.dart';

import '../../../generated/assets.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/toasts/messages_toasts.dart';
import '../../shared/toasts/shared_report_dialog.dart';

part 'comments_store.g.dart';

class CommentsStore = CommentsStoreBase with _$CommentsStore;

abstract class CommentsStoreBase with Store {
  late CommentsRepo _commentsRepo;

  @observable
  ComponentState pageState = ComponentState.FETCHING_DATA;

  ObservableList<Comment> comments = ObservableList<Comment>();
  PaginationModel<Comment>? commentsPagination;

  final PagingController<int, Comment> commentsPagingController =
      PagingController(firstPageKey: 1);

  String? refId;

  User? user;

  FormGroup form = FormGroup({
    'comment': FormControl<String>(
      validators: [Validators.required],
    ),
  });

  @action
  Future initValues(String refId, CommentsRepo repo) async {
    this._commentsRepo = repo;
    this.refId = refId;
    commentsPagingController.addPageRequestListener((pageKey) {
      getComments(pageKey);
    });

    pageState = ComponentState.FETCHING_DATA;
    user = await SharedPreferencesHelper.getUser();
    pageState = ComponentState.SHOW_DATA;
  }

  Future<void> getComments(int pageKey) async {
    commentsPagination = await _commentsRepo.getComments(pageKey, 10, refId!);

    if (commentsPagination!.currentPage == commentsPagination!.totalPages) {
      commentsPagingController.appendLastPage(commentsPagination!.items);
    } else {
      final nextPageKey = pageKey + 1;
      commentsPagingController.appendPage(commentsPagination!.items, nextPageKey);
    }
  }

  @action
  Future pickImage() async {
    final xfile = await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (xfile != null) file = File(xfile.path);
  }

  Future<void> makeInteraction(Comment comment, String type) async {
    final res = await _commentsRepo.makeInteraction(refId!, comment.id, type);
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
    commentsPagingController.itemList?.add(Comment(
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

    _commentsRepo.addComment(form.control('comment').value, refId!, file: file).then((value) {
      commentsPagingController.itemList!.last = value;
      commentsPagingController.notifyListeners();
    });
    file = null;
    form.control('comment').value = null;
  }

  void goToReplies(Comment comment, BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child:
                Container(height: 80.h, child: RepliesPage(refId!, comment, _commentsRepo)),
          );
        });
  }

  Future makeReaction(Comment comment, String type) async {
    _commentsRepo.makeInteraction(refId!, comment.id, type);
  }

  Future updateComment(Comment comment) async {
    Modular.to
        .pushNamed('/home/roadmapDetails/updateComment/', arguments: [comment]).then((value) {
      if (value != null) {
        final editedComment = value as Comment;
        final oldCommentIndex = commentsPagingController.itemList!.indexOf(comment);

        _commentsRepo
            .updateComment(editedComment.text, refId!, comment.id, file: comment.file)
            .then((value) {
          if (value != null) {
            commentsPagingController.itemList?[oldCommentIndex] = value;
            commentsPagingController.notifyListeners();
          }
        });
        commentsPagingController.itemList?[oldCommentIndex] = editedComment;
        commentsPagingController.itemList?[oldCommentIndex].attachment = "nowLoading";
        commentsPagingController.notifyListeners();
      }
    });
  }

  Future deleteComment(Comment comment) async {
    _commentsRepo.deleteComment(refId!, comment.id).then((value) {
      if (value) {
        commentsPagingController.itemList!.remove(comment);
        commentsPagingController.notifyListeners();
      }
    });
  }

  Future showReportOptionsDialog(BuildContext context, Comment comment) async {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.notifications,
                          color: AppColors.primary,
                          size: 50,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text('What do you want to do?'),
                        Spacer(),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(1);
                                  },
                                  child: Text(
                                    'Report Comment',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(2);
                                  },
                                  child: Text(
                                    'Report User',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      ]),
                    ),
                  )),
            )).then((value) {
      if (value != null) {
        if (value == 1) {
          reportComment(context, comment);
        } else if (value == 2) {
          reportLearner(context, comment);
        }
      }
    });
  }

  Future showEditDeleteDialog(BuildContext context, Comment comment) async {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        Icon(
                          Icons.notifications,
                          color: AppColors.primary,
                          size: 50,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text('What do you want to do?'),
                        Spacer(),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    updateComment(comment);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    deleteComment(comment);
                                  },
                                  child: Text(
                                    'Delete',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      ]),
                    ),
                  )),
            ));
  }

  Future reportLearner(BuildContext context, Comment comment) async {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height * 0.5,
                child: SumbitMessageDialog()),
          );
        }).then((value) {
      if (value != null) {
        _commentsRepo.reportUser(comment.learnerId, value.toString()).then((value) {
          if (value) {
            showSuccessToast('Your Report has been sent');
          }
        });
      }
    });
  }

  Future reportComment(BuildContext context, Comment comment) async {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height * 0.5,
                child: SumbitMessageDialog()),
          );
        }).then((value) {
      if (value != null) {
        _commentsRepo.reportComment(comment.id, value.toString()).then((value) {
          if (value) {
            showSuccessToast('Your Report has been sent');
          }
        });
      }
    });
  }

  final reactionsList = [
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsLike, width: 50, height: 50), value: 'Like'),
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsLove, width: 50, height: 50), value: 'Love'),
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsHaha, width: 50, height: 50), value: 'Haha'),
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsWow, width: 50, height: 50), value: 'Wow'),
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsSad, width: 50, height: 50), value: 'Sad'),
    flutterReactions.Reaction(
        icon: Image.asset(Assets.assetsAngry, width: 50, height: 50), value: 'Angry')
  ];
}
