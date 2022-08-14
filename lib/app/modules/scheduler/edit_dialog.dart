import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:roadmap/app/modules/scheduler/scheduler_store.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';

class EditDatePage extends StatefulWidget {
  CalendarEventData event;

  EditDatePage(this.event);

  @override
  _EditDatePageState createState() => _EditDatePageState();
}

class _EditDatePageState extends State<EditDatePage> {
  final FormGroup form =
      FormGroup({'startTime': FormControl<TimeOfDay>(), 'weekday': FormControl<int>()});

  @override
  void initState() {
    super.initState();
    this.form.control('startTime').value = TimeOfDay.fromDateTime(widget.event.date);
    this.form.control('weekday').value = widget.event.date.weekday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Edit ${widget.event.title}', style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 20),
            ReactiveForm(
                formGroup: this.form,
                child: Column(
                  children: [
                    weekdayWidget(context),
                    SizedBox(
                      height: 10,
                    ),
                    ReactiveTimePicker(
                      builder: (context, delegate, builder) {
                        return ReactiveTextField(
                          readOnly: true,
                          formControlName: 'startTime',
                          decoration: InputDecoration(
                              labelText: 'Time',
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () {
                                    delegate.showPicker();
                                  })),
                        );
                      },
                      formControlName: 'startTime',
                    ),
                  ],
                )),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  final startDate = DateTime.now()
                      .mostRecentWeekday(DateTime.now(), form.control('weekday').value);
                  final newStartTime = form.control('startTime').value as TimeOfDay;
                  final dateToSend=DateTime(startDate.year, startDate.month, startDate.day,
                      newStartTime.hour, newStartTime.minute);
                  final editedEvent = CalendarEventData(
                      title: widget.event.title,
                      event: widget.event.event,
                      endTime: dateToSend.add(Duration(minutes: 120)),
                      startTime: dateToSend,
                      endDate: dateToSend.add(Duration(minutes: 120)),
                      date: dateToSend);
                  Navigator.of(context).pop(editedEvent);
                },
                child: Text('Submit',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: AppColors.white))),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  Widget weekdayWidget(BuildContext context) {
    return ReactiveDropdownField<int>(
        isExpanded: false,
        items: Day.values
            .map((e) => DropdownMenuItem(
                  value: e.weekday,
                  child: Text(e.name),
                ))
            .toList(),
        formControlName: 'weekday',
        decoration: InputDecoration(counter: Container(), labelText: 'Day'));
  }
}

class Day {
  int weekday;
  String name;

  Day(this.weekday, this.name);

  static final monday = Day(1, 'Monday');
  static final tuesday = Day(2, 'Tuesday');
  static final wednesday = Day(3, 'Wednesday');
  static final thursday = Day(4, 'Thursday');
  static final friday = Day(5, 'Friday');
  static final saturday = Day(6, 'Saturday');
  static final sunday = Day(7, 'Sunday');

  static final values = [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
}
