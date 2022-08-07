import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:roadmap/app/modules/scheduler/scheduler_repo.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/scheduler_model.dart';
import 'package:roadmap/app/shared/services/notification_service.dart';
import 'package:roadmap/app/shared/toasts/loading_toast.dart';
import 'package:roadmap/app/shared/widgets/component_template.dart';

part 'scheduler_store.g.dart';

class SchedulerStore = SchedulerStoreBase with _$SchedulerStore;

abstract class SchedulerStoreBase with Store {
  SchedulerRepo _schedulerRepo;

  SchedulerStoreBase(this._schedulerRepo, this.referenceId);

  @observable
  ComponentState componentState = ComponentState.FETCHING_DATA;

  EventController controller = EventController();

  LearnWeek? learnWeek;

  String? referenceId;

  @action
  Future initValues(BuildContext context, EventController eventController) async {
    try {
      componentState = ComponentState.FETCHING_DATA;
      this.controller = eventController;
      learnWeek = await _schedulerRepo.getScheduler();
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
        endDate: DateTime(nextDay.year, nextDay.month, nextDay.day, endHour, endMinute),
        date: DateTime(nextDay.year, nextDay.month, nextDay.day, startHour, startMinute),
        title: 'Server Mock Name',
        endTime: DateTime(nextDay.year, nextDay.month, nextDay.day, endHour, endMinute),
        startTime: DateTime(nextDay.year, nextDay.month, nextDay.day, startHour, startMinute),
      ));
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

    await _schedulerRepo.updateScheduler(learnWeekToSend);
    NotificationService.instance.scheduleNotifications(learnWeek!);
    closeLoading();
  }

  handleDateLongPress(DateTime date) {
    controller.add(CalendarEventData(
      endDate: date.add(Duration(minutes: 120)),
      date: date,
      event: date.toString(),
      title: 'Some Test',
      endTime: date.add(Duration(minutes: 120)),
      startTime: date,
    ));
  }

  int calcWeekdays() {
    int sum = 0;
    if (!learnWeek!.sun.isHoliday) sum++;
    if (!learnWeek!.mon.isHoliday) sum++;
    if (!learnWeek!.tue.isHoliday) sum++;
    if (!learnWeek!.wed.isHoliday) sum++;
    if (!learnWeek!.thu.isHoliday) sum++;
    if (!learnWeek!.fri.isHoliday) sum++;
    if (!learnWeek!.sat.isHoliday) sum++;

    return sum;
  }
}

extension DateTimeExtension on DateTime {
  DateTime mostRecentWeekday(DateTime date, int weekday) =>
      DateTime(date.year, date.month, date.day - (date.weekday - weekday) % 7);
}
