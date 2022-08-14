import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/roadmap/roadmap_repo.dart';
import 'package:roadmap/app/modules/scheduler/edit_dialog.dart';
import 'package:roadmap/app/modules/scheduler/scheduler_repo.dart';
import 'package:roadmap/app/modules/scheduler/user_roadmaps_page.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/models/scheduler_model.dart';
import 'package:roadmap/app/shared/services/notification_service.dart';
import 'package:roadmap/app/shared/toasts/loading_toast.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

import '../../shared/theme/app_colors.dart';

part 'scheduler_store.g.dart';

class SchedulerStore = SchedulerStoreBase with _$SchedulerStore;

abstract class SchedulerStoreBase with Store {
  SchedulerRepo _schedulerRepo;
  RoadmapRepo _roadmapRepo;

  SchedulerStoreBase(this._schedulerRepo, this._roadmapRepo, this.referenceId);

  @observable
  ComponentState componentState = ComponentState.FETCHING_DATA;

  EventController controller = EventController();

  RoadmapModel? roadmap;

  LearnWeek? learnWeek;

  SchedulerModel? schedulerModel;

  String? referenceId;

  List<Roadmap> userRoadmaps = [];

  List<Color> colors = [
    Colors.deepOrange,
    Colors.blueAccent,
    Colors.redAccent,
    AppColors.primary,
    Colors.purple
  ];

  Map<String, dynamic> info = {};

  @action
  Future initValues(BuildContext context, EventController eventController) async {
    try {
      componentState = ComponentState.FETCHING_DATA;
      this.controller = eventController;
      schedulerModel = await _schedulerRepo.getScheduler();
      learnWeek = schedulerModel!.learnWeek;
      roadmap = this.referenceId == null || this.referenceId == ""
          ? null
          : await _roadmapRepo.getRoadmapById(referenceId!);
      userRoadmaps = schedulerModel!.roadmaps ?? [];
      if (roadmap != null) {
        userRoadmaps.add(Roadmap(id: roadmap!.id, name: roadmap!.title));
      }
      for (int i = 0; i < userRoadmaps.length; i++) {
        if (info[userRoadmaps[i].id] == null) {
          info[userRoadmaps[i].id] = {'name': userRoadmaps[i].name, 'color': colors[i % 5]};
        }
      }
      initData(context);
      componentState = ComponentState.SHOW_DATA;
    } on AppException catch (e) {}
  }

  void mapDates(BuildContext context, int weekday, List<SchedulerDate> dates) {
    dates.forEach((element) {
      final startHour = int.parse(element.startAt!.split(':')[0]);
      final startMinute = int.parse(element.startAt!.split(':')[1]);
      final endHour = int.parse(element.endAt!.split(':')[0]);
      final endMinute = int.parse(element.endAt!.split(':')[1]);
      final nextDay = DateTime.now().mostRecentWeekday(DateTime.now(), weekday);
      controller.add(CalendarEventData(
        event: element.referenceId,
        color: info[element.referenceId]['color'],
        endDate: DateTime(nextDay.year, nextDay.month, nextDay.day, endHour, endMinute),
        date: DateTime(nextDay.year, nextDay.month, nextDay.day, startHour, startMinute),
        title: info[element.referenceId]['name'],
        endTime: DateTime(nextDay.year, nextDay.month, nextDay.day, endHour, endMinute),
        startTime: DateTime(nextDay.year, nextDay.month, nextDay.day, startHour, startMinute),
      ));
      controller.notifyListeners();
    });
  }

  initData(BuildContext context) {
    mapDates(context, DateTime.saturday, learnWeek!.sat.dates);
    mapDates(context, DateTime.sunday, learnWeek!.sun.dates);
    mapDates(context, DateTime.monday, learnWeek!.mon.dates);
    mapDates(context, DateTime.tuesday, learnWeek!.tue.dates);
    mapDates(context, DateTime.wednesday, learnWeek!.wed.dates);
    mapDates(context, DateTime.thursday, learnWeek!.thu.dates);
    mapDates(context, DateTime.friday, learnWeek!.fri.dates);
  }

  Future updateScheduler(BuildContext context) async {
    showLoading();
    final learnWeekToSend = LearnWeek(
        sat: WeekDay(
            isHoliday: false,
            dates: controller.events
                .where((element) => element.date.weekday == DateTime.saturday)
                .map((e) => SchedulerDate.fromScheduler(e))
                .toList()),
        sun: WeekDay(
            isHoliday: false,
            dates: controller.events
                .where((element) => element.date.weekday == DateTime.sunday)
                .map((e) => SchedulerDate.fromScheduler(e))
                .toList()),
        mon: WeekDay(
            isHoliday: false,
            dates: controller.events
                .where((element) => element.date.weekday == DateTime.monday)
                .map((e) => SchedulerDate.fromScheduler(e))
                .toList()),
        tue: WeekDay(
            isHoliday: false,
            dates: controller.events
                .where((element) => element.date.weekday == DateTime.tuesday)
                .map((e) => SchedulerDate.fromScheduler(e))
                .toList()),
        wed: WeekDay(
            isHoliday: false,
            dates: controller.events
                .where((element) => element.date.weekday == DateTime.wednesday)
                .map((e) => SchedulerDate.fromScheduler(e))
                .toList()),
        thu: WeekDay(
            isHoliday: false,
            dates: controller.events
                .where((element) => element.date.weekday == DateTime.thursday)
                .map((e) => SchedulerDate.fromScheduler(e))
                .toList()),
        fri: WeekDay(
            isHoliday: false,
            dates: controller.events
                .where((element) => element.date.weekday == DateTime.friday)
                .map((e) => SchedulerDate.fromScheduler(e))
                .toList()));

    log("learn week is ${learnWeekToSend}");

    await _schedulerRepo.updateScheduler(learnWeekToSend);
    NotificationService.instance.scheduleNotifications(learnWeekToSend, userRoadmaps);
    if (Modular.to.canPop()) Modular.to.pop(true);
    closeLoading();
  }

  handleDateLongPress(BuildContext context, DateTime date) {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) => Dialog(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: UserRoadmapsPage(userRoadmaps)),
            )).then((value) {
      if (value != null) {
        final selectedRoadmap = value as Roadmap;
        controller.add(CalendarEventData(
          endDate: date.add(Duration(minutes: 120)),
          date: date,
          event: selectedRoadmap.id,
          title: selectedRoadmap.name,
          endTime: date.add(Duration(minutes: 120)),
          startTime: date,
        ));
      }
    });
  }

  void onEventTapped(BuildContext context, CalendarEventData event) {
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
                                    showEditDialog(event, context);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Visibility(
                              visible: controller.events
                                      .where((element) => element.event == event.event)
                                      .length >
                                  1,
                              child: Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      controller.remove(event);
                                      controller.notifyListeners();
                                    },
                                    child: Text(
                                      'Delete',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    )),
                              ),
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

  int calcWeekdays() {
    int sum = 0;
    if (learnWeek != null) {
      if (!learnWeek!.sun.isHoliday) sum++;
      if (!learnWeek!.mon.isHoliday) sum++;
      if (!learnWeek!.tue.isHoliday) sum++;
      if (!learnWeek!.wed.isHoliday) sum++;
      if (!learnWeek!.thu.isHoliday) sum++;
      if (!learnWeek!.fri.isHoliday) sum++;
      if (!learnWeek!.sat.isHoliday) sum++;
    }

    return sum;
  }

  void showEditDialog(CalendarEventData event, BuildContext context) {
    showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: EditDatePage(event)),
            )).then((value) {
      if (value != null) {
        final editedEvent = value as CalendarEventData;
        controller.remove(event);
        controller.notifyListeners();

        log("events are ${controller.events}");
        controller.add(editedEvent);
        log("events are ${controller.events}");
      }
    });
  }
}

extension DateTimeExtension on DateTime {
  DateTime mostRecentWeekday(DateTime date, int weekday) =>
      DateTime(date.year, date.month, date.day - (date.weekday - weekday) % 7);
}
