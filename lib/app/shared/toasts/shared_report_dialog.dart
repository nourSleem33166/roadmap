import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SumbitMessageDialog extends StatelessWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Report Something',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primary),
          ),
          SizedBox(height: 15),
          TextField(
            controller: controller,
            minLines: 4,
            maxLines: 4,
            decoration: InputDecoration(labelText: 'Message'),
          ),
          Spacer(),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        Navigator.of(context).pop(controller.text);
                      }
                    },
                    child: Text(
                      'Send',
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
                    },
                    child: Text(
                      'Cancel',
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
