import 'package:flutter/widgets.dart';

import 'app_controller.dart';

/// Makes the [AppController] available to the widget tree and rebuilds
/// dependents when it notifies.
class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    super.key,
    required AppController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// Access without subscribing to rebuilds (for callbacks).
  static AppController read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
