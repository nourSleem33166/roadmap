import 'package:dio/dio.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/scheduler_model.dart';

class SchedulerRepo {
  Dio _dio;

  SchedulerRepo(this._dio);

  Future<SchedulerModel> getScheduler() async {
    final response = await _dio.get('learner/profile/scheduler');
    if (response.statusCode == 200) return SchedulerModel.fromJson(response.data);
    throw AppException.unknown();
  }

  Future<bool> updateScheduler(LearnWeek learnWeek) async {
    final response = await _dio.put('learner/profile/scheduler', data: learnWeek.toJson());
    if (response.statusCode == 200) return true;
    return false;
  }
}
