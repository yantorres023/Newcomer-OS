import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'data/dataset_loader.dart';
import 'data/local_store.dart';
import 'services/analytics.dart';
import 'services/reminder_service.dart';
import 'state/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  final controller = AppController(
    store: LocalStore(FileStoreBackend(dir)),
    datasetLoader: DatasetLoader(),
    reminders: LocalNotificationScheduler(),
    analytics: DebugAnalyticsSink(),
  );
  runApp(ErstmalApp(controller: controller));
  await controller.init();
}
