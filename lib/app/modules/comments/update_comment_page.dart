import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';

import '../../shared/models/comment_model.dart';

class UpdateCommentPage extends StatefulWidget {
  Comment comment;

  UpdateCommentPage(this.comment);

  @override
  _UpdateCommentPageState createState() => _UpdateCommentPageState();
}

class _UpdateCommentPageState extends State<UpdateCommentPage> {
  FormGroup formGroup = FormGroup({
    'comment': FormControl<String>(validators: [Validators.required])
  });

  File? file;

  @override
  void initState() {
    super.initState();
    formGroup.control('comment').value = widget.comment.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: Text('Edit')),
      body: Observer(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                ),
                width: double.infinity,
                child: ReactiveForm(
                  formGroup: formGroup,
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(children: [
                        ReactiveTextField(
                            showErrors: (control) => false,
                            formControlName: 'comment',
                            decoration: InputDecoration()),
                        if (widget.comment.attachment != null &&
                            widget.comment.attachment != "")
                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: InkWell(
                                onTap: () {
                                  pickImage();
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: file != null
                                        ? Image.file(file!)
                                        : Image.network(
                                            widget.comment.attachment!,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            width: 100,
                                          )),
                              ))
                      ])),
                      SizedBox(width: 10),
                      Builder(builder: (context) {
                        final form = ReactiveForm.of(context);

                        return Row(
                          children: [
                            ElevatedButton(
                                onPressed: form!.valid
                                    ? () {
                                        widget.comment.text =
                                            formGroup.control('comment').value;
                                        widget.comment.file = file;
                                        Modular.to.pop(Comment.copyWith(widget.comment));
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
          ),
        );
      }),
    );
  }

  Future pickImage() async {
    final xfile = await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (xfile != null) file = File(xfile.path);
    setState(() {

    });
  }
}
