import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/modules/scheduler/scheduler_store.dart';
import 'package:roadmap/app/shared/theme/app_colors.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

class SchedulerPage extends StatefulWidget {
  @override
  _SchedulerPageState createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  final store = Modular.get<SchedulerStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    store.initValues(context, CalendarControllerProvider.of(context).controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ElevatedButton(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Submit',
                style:
                    Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.white)),
          ),
          onPressed: () {
            store.updateScheduler(context);
          },
        ),
        body: Center(
          child: Observer(builder: (context) {
            return ComponentTemplate(
              state: store.componentState,
              screen: SingleChildScrollView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                child: WeekView(
                    scrollOffset: 0,
                    weekDays: store.learnWeek != null
                        ? [
                            if (!store.learnWeek!.sat.isHoliday) WeekDays.saturday,
                            if (!store.learnWeek!.sun.isHoliday) WeekDays.sunday,
                            if (!store.learnWeek!.mon.isHoliday) WeekDays.monday,
                            if (!store.learnWeek!.tue.isHoliday) WeekDays.tuesday,
                            if (!store.learnWeek!.wed.isHoliday) WeekDays.wednesday,
                            if (!store.learnWeek!.thu.isHoliday) WeekDays.thursday,
                            if (!store.learnWeek!.fri.isHoliday) WeekDays.friday,
                          ]
                        : WeekDays.values,
                    width: store.calcWeekdays() / 3 < 1
                        ? null
                        : MediaQuery.of(context).size.width * (store.calcWeekdays() / 3),
                    showWeekends: true,
                    weekDayBuilder: (date) {
                      return Center(
                          child: Text(
                        DateFormat('EEE', 'en').format(date),
                        style: date.weekday == DateTime.now().weekday
                            ? Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: AppColors.primary)
                            : Theme.of(context).textTheme.bodyMedium,
                      ));
                    },
                    timeLineBuilder: (date) {
                      return Center(
                        child: Text(DateFormat.jm('en').format(date)),
                      );
                    },
                    eventTileBuilder: (weekDate, eventList, rect, startTime, endTime) {
                      return Column(
                        children: eventList
                            .map((e) => Container(
                                  width: rect.width,
                                  height: rect.height,
                                  child: Card(
                                      color: e.color,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            e.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: AppColors.white),
                                          ),
                                        ),
                                      )),
                                ))
                            .toList(),
                      );
                    },
                    heightPerMinute: 1,
                    weekPageHeaderBuilder: (_, __) {
                      return Container();
                    },
                    onEventTap: (event, date) {
                      log("event is ${event[0]}");
                      store.onEventTapped(context, event[0]);
                    },
                    maxDay: DateTime.now(),
                    minDay: DateTime.now(),
                    initialDay: DateTime.now(),

                    onDateLongPress: (date) {
                      store.handleDateLongPress(context, date);
                    }),
              ),
            );
          }),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    store.controller.dispose();
  }
}
