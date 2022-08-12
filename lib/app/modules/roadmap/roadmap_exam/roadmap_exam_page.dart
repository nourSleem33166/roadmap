import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_exam/roadmap_exam_store.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';

import '../../../shared/models/exam.dart';

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final store = Modular.get<ExamStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Text('Exam'),
            Spacer(),
            StreamBuilder(
                stream: Stream.periodic(Duration(seconds: 1)).asBroadcastStream(),
                builder: (context, snapshot) {
                  final duration =
                      store.exam.exam.expiredAt.toLocal().difference(DateTime.now());
                  return Text(
                    'Time Left: ${_printDuration(duration)}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 16, color: AppColors.white, fontWeight: FontWeight.bold),
                  );
                }),
            SizedBox(
              width: 5,
            )
          ],
        ),
      ),
      body: Observer(builder: (context) {
        final notPassedLevels = store.exam.exam.levels
            .where((element) => element.isPassed.value == null)
            .toList();

        if (notPassedLevels.isNotEmpty)
          return levelWidget(context, notPassedLevels[0]);
        else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Spacer(),
                  Text(
                    'Exam Passed: ${store.examResult['examPassed'] ? "Yes" : "No"}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 30),
                  ),
                  Spacer(),
                ],
              ),
            ],
          );
        }
      }),
    );
  }

  Widget levelWidget(
    BuildContext context,
    Level level,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            level.title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.primary),
          ),
          SizedBox(
            height: 10,
          ),
          ...level.questions.map((e) => questionWidget(context, e)).toList(),
          SizedBox(
            height: 20,
          ),
          Observer(builder: (context) {
            return ElevatedButton(
                onPressed: () {
                  store.submitLevel(level);
                },
                child: Text('Submit This Level',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.white)));
          })
        ],
      ),
    );
  }

  Widget questionWidget(BuildContext context, Question question) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(question.type == "singleChoice" ? 'Single choice' : 'Multiple choice',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.primary)),
                  Spacer(),
                  Text('${question.mark} Marks',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.primary)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    question.text,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              SizedBox(height: 10),
              ...question.options
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: buildOptionWidget(context, question, e),
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionWidget(BuildContext context, Question question, Option option) {
    return Observer(builder: (context) {
      return Row(
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () {
                    store.selectOption(option, question);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: option.isCorrect.value
                                    ? AppColors.primary
                                    : AppColors.white)),
                      ))),
              SizedBox(
                width: 10,
              ),
              Text(
                option.text,
                style: Theme.of(context).textTheme.titleMedium,
              )
            ],
          )
        ],
      );
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    super.dispose();
    Modular.dispose<ExamStore>();
  }
}
