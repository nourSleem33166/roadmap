import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:roadmap/app/modules/comments/comments_repo.dart';
import 'package:roadmap/app/modules/comments/comments_store.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../shared/models/comment_model.dart';
import '../../shared/models/interaction.dart';

class CommentsPage extends StatefulWidget {
  String refId;
  CommentsRepo _repo;

  CommentsPage(this.refId, this._repo);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final store = Modular.get<CommentsStore>();

  @override
  void initState() {
    super.initState();
    store.initValues(widget.refId, widget._repo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(builder: (context) {
        return ComponentTemplate(
          state: store.pageState,
          screen: Column(children: [
            commentsHeader(context),
            Expanded(child: buildComments()),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              width: double.infinity,
              child: ReactiveForm(
                formGroup: store.form,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(store.user?.personalImage ?? ""),
                      radius: 22,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        ReactiveTextField(
                            showErrors: (control) => false,
                            formControlName: 'comment',
                            decoration: InputDecoration()),
                        if (store.file != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                store.file!,
                                height: 100,
                                fit: BoxFit.cover,
                                width: 100,
                              ),
                            ),
                          )
                      ],
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Builder(builder: (context) {
                      final form = ReactiveForm.of(context);

                      return Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                store.pickImage();
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColors.white,
                                size: 20,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                              onPressed: form!.valid
                                  ? () {
                                      store.sendComment();
                                    }
                                  : null,
                              child: Icon(
                                Icons.send,
                                color: AppColors.white,
                                size: 20,
                              )),
                        ],
                      );
                    }),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            )
          ]),
        );
      }),
    );
  }

  Widget buildComments() {
    return Observer(builder: (context) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: PagedListView<int, Comment>(
              pagingController: store.commentsPagingController,
              builderDelegate: PagedChildBuilderDelegate<Comment>(
                  itemBuilder: (context, item, index) => Padding(
                      padding: const EdgeInsets.all(8.0), child: commentItem(item)))));
    });
  }

  Widget commentItem(Comment comment) {
    comment.learner.personalImage =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwclg60fm6EHOyIjBqSqdxAD7i1yNPPGeOJQ&usqp=CAU';
    return InkWell(
      onLongPress: comment.learnerId == store.user!.id
          ? () {
              store.showEditDeleteDialog(context, comment);
            }
          : null,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(comment.learner.personalImage),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15), color: Colors.black12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.learner.firstName + " " + comment.learner.lastName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              comment.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontSize: 15),
                            ),
                            Visibility(
                                visible: comment.attachment != null,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: comment.attachment != "nowLoading",
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          comment.attachment ?? "",
                                          loadingBuilder: (context, child, progress) {
                                            if (progress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          },
                                        ),
                                      ),
                                      replacement: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Observer(builder: (context) {
                          return Text(comment.interactionValue.value?.type ?? "Like",
                              style: comment.interactionValue.value != null
                                  ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: getReactionTextColor(
                                          comment.interactionValue.value))
                                  : Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: getReactionTextColor(
                                          comment.interactionValue.value)));
                        }),
                        ReactionButton(
                            boxReactionSpacing: 15,
                            boxPosition: VerticalPosition.TOP,
                            boxRadius: 40,
                            boxPadding: EdgeInsets.all(10),
                            itemScale: 0.5,
                            initialReaction: comment.interactionValue.value?.type != null
                                ? store.reactionsList.singleWhere((element) =>
                                    element.value == comment.interactionValue.value?.type)
                                : null,
                            onReactionChanged: (reaction) {
                              store.onReactionChanged(comment, reaction.toString());
                            },
                            reactions: store.reactionsList),
                        InkWell(
                          onTap: () {
                            store.goToReplies(comment, context);
                          },
                          child: Text('Reply',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold, color: Colors.black45)),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Color? getReactionTextColor(Interaction? interaction) {
    if (interaction == null)
      return null;
    else if (interaction.type == 'Like') {
      print("like selected");
      return Color(0xff558dff);
    } else if (interaction.type == 'Love')
      return Color(0xfff55065);
    else if (interaction.type == 'Haha' ||
        interaction.type == 'Wow' ||
        interaction.type == 'Sad')
      return Color(0xffffda6a);
    else
      return Color(0xfffa8a68);
  }

  Widget commentsHeader(BuildContext context) {
    return Container(
      height: 62,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Comments',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.primary),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Modular.dispose<CommentsStore>();
  }
}
