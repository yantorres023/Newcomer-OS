import 'package:flutter/foundation.dart';

/// Product events (see docs/product/ANALYTICS.md). EXPERIMENTAL.
enum AnalyticsEvent {
  onboardingStarted,
  onboardingCompleted,
  roadmapGenerated,
  taskViewed,
  officialSourceOpened,
  reminderCreated,
  taskCompleted,
  taskReopened,
  languageChanged,
  profileUpdated,
  dataDeleted,
}

/// Properties are restricted to non-identifying values (rule ids, counts,
/// language codes). Profile answers and dates are never passed here.
typedef AnalyticsProps = Map<String, Object>;

abstract class AnalyticsSink {
  void track(AnalyticsEvent event, [AnalyticsProps props = const {}]);
}

/// V1 ships without any remote analytics. Events are only printed in debug
/// builds so developers can check instrumentation; release builds drop them.
class DebugAnalyticsSink implements AnalyticsSink {
  @override
  void track(AnalyticsEvent event, [AnalyticsProps props = const {}]) {
    if (kDebugMode) debugPrint('[analytics] ${event.name} $props');
  }
}

class RecordingAnalyticsSink implements AnalyticsSink {
  final events = <(AnalyticsEvent, AnalyticsProps)>[];
  @override
  void track(AnalyticsEvent event, [AnalyticsProps props = const {}]) =>
      events.add((event, props));
}
