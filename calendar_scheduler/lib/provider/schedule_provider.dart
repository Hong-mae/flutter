import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {
  // final AuthRepository authRepository;
  final ScheduleRepository scheduleRepository;

  String? accessToken;
  String? refreshToken;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({
    // required this.authRepository,
    required this.scheduleRepository,
  });

  void getSchedules({required DateTime date}) async {
    final resp = await scheduleRepository.getSchedules(
      date: date,
      // accessToken: accessToken!,
    );

    cache.update(date, (value) => resp, ifAbsent: () => resp);

    notifyListeners();
  }

  void createSchedule({required ScheduleModel schedule}) async {
    final targetDate = schedule.date;

    final uuid = Uuid();

    final tempId = uuid.v4();
    final newSchedule = schedule.copyWith(id: tempId);

    cache.update(
      targetDate,
      (value) =>
          [...value, newSchedule]
            ..sort((a, b) => a.start_time.compareTo(b.start_time)),
      ifAbsent: () => [newSchedule],
    );

    notifyListeners();

    try {
      final savedSchedule = await scheduleRepository.createSchedule(
        schedule: schedule,
        // accessToken: accessToken!,
      );

      cache.update(
        targetDate,
        (value) =>
            value
                .map((e) => e.id == tempId ? e.copyWith(id: savedSchedule) : e)
                .toList(),
      );
    } catch (e) {
      cache.update(
        targetDate,
        (value) => value.where((e) => e.id != tempId).toList(),
      );
    }

    // notifyListeners();
  }

  void deleteSchedule({required DateTime date, required String id}) async {
    final targetSchedule = cache[date]!.firstWhere((e) => e.id == id);

    cache.update(date, (value) => value.where((e) => e.id != id).toList());

    notifyListeners();

    try {
      await scheduleRepository.deleteSchedule(
        id: id,
        // accessToken: accessToken!,
      );
    } catch (e) {
      cache.update(
        date,
        (value) =>
            [...value, targetSchedule]
              ..sort((a, b) => a.start_time.compareTo(b.start_time)),
      );
    }

    notifyListeners();
  }

  void changeSelectedDate({required DateTime date}) {
    selectedDate = date;
    notifyListeners();
  }

  // updateToken({String? refreshToken, String? accessToken}) {
  //   if (refreshToken != null) {
  //     this.refreshToken = refreshToken;
  //   }

  //   if (accessToken != null) {
  //     this.accessToken = accessToken;
  //   }

  //   notifyListeners();
  // }

  // Future<void> register({
  //   required String email,
  //   required String password,
  // }) async {
  //   final resp = await authRepository.register(
  //     email: email,
  //     password: password,
  //   );

  //   updateToken(accessToken: resp.accessToken, refreshToken: resp.refreshToken);
  // }

  // Future<void> login({required String email, required String password}) async {
  //   final resp = await authRepository.login(email: email, password: password);

  //   updateToken(accessToken: resp.accessToken, refreshToken: resp.refreshToken);
  // }

  // logout() {
  //   refreshToken = null;
  //   accessToken = null;

  //   cache = {};

  //   notifyListeners();
  // }

  // rotateToken({
  //   required String refreshToken,
  //   required bool isRefreshToken,
  // }) async {
  //   if (isRefreshToken) {
  //     final token = await authRepository.rotateRefreshToken(
  //       refreshToken: refreshToken,
  //     );

  //     this.refreshToken = token;
  //   } else {
  //     final token = await authRepository.rotateAccessToken(
  //       refreshToken: refreshToken,
  //     );

  //     accessToken = token;
  //   }

  //   notifyListeners();
  // }
}
