import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../domain/local_date.dart';

/// Text shown in a notification. The caller decides whether the task title is
/// included (privacy setting) — the scheduler never sees profile data.
class ReminderContent {
  const ReminderContent({required this.title, required this.body});
  final String title;
  final String body;
}

abstract class ReminderScheduler {
  Future<void> init();

  /// Returns false if permission was denied.
  Future<bool> requestPermission();

  Future<void> schedule({
    required int id,
    required LocalDate date,
    required ReminderContent content,
  });

  Future<void> cancel(int id);
  Future<void> cancelAll();
}

/// Stable positive 31-bit notification id derived from a rule id (FNV-1a).
int notificationIdFor(String ruleId) {
  var hash = 0x811c9dc5;
  for (final unit in ruleId.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash & 0x7fffffff;
}

/// Hour of day (device local time) at which reminders fire.
const reminderHour = 9;

/// Schedules on-device notifications. Nothing leaves the device.
class LocalNotificationScheduler implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  @override
  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } on Object catch (e) {
      // Fall back to UTC; reminders may then fire at a shifted hour.
      debugPrint('Timezone lookup failed: ${e.runtimeType}');
      tz.setLocalLocation(tz.UTC);
    }
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings: settings);
    _ready = true;
  }

  @override
  Future<bool> requestPermission() async {
    await init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }

  @override
  Future<void> schedule({
    required int id,
    required LocalDate date,
    required ReminderContent content,
  }) async {
    await init();
    final when = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      reminderHour,
    );
    if (when.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      id: id,
      title: content.title,
      body: content.body,
      scheduledDate: when,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          'Task reminders',
          channelDescription: 'Reminders you set for your checklist tasks',
          importance: Importance.defaultImportance,
          visibility: NotificationVisibility.private,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Inexact scheduling avoids the exact-alarm permission; a reminder a
      // few minutes late is fine for day-level deadlines.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(int id) async {
    await init();
    await _plugin.cancel(id: id);
  }

  @override
  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }
}

/// In-memory scheduler for tests and platforms without notifications.
class FakeReminderScheduler implements ReminderScheduler {
  final scheduled = <int, (LocalDate, ReminderContent)>{};
  bool permissionGranted = true;

  @override
  Future<void> init() async {}
  @override
  Future<bool> requestPermission() async => permissionGranted;
  @override
  Future<void> schedule({
    required int id,
    required LocalDate date,
    required ReminderContent content,
  }) async => scheduled[id] = (date, content);
  @override
  Future<void> cancel(int id) async => scheduled.remove(id);
  @override
  Future<void> cancelAll() async => scheduled.clear();
}
