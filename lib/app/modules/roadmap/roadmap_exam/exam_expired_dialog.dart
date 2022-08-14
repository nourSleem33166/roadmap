import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';

class ExamExpiredPage extends StatelessWidget {
  const ExamExpiredPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Text('Exam Expired !!!'),
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
                    },
                    child: Text(
                      'OK',
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
    );
  }
}
