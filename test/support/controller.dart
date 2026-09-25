import 'package:newcomer_os/data/dataset_loader.dart';
import 'package:newcomer_os/data/local_store.dart';
import 'package:newcomer_os/domain/local_date.dart';
import 'package:newcomer_os/services/analytics.dart';
import 'package:newcomer_os/services/reminder_service.dart';
import 'package:newcomer_os/state/app_controller.dart';

class Harness {
  Harness({LocalDate? today, MemoryStoreBackend? backend})
    : backend = backend ?? MemoryStoreBackend(),
      today = today ?? LocalDate(2026, 10, 1) {
    controller = AppController(
      store: LocalStore(this.backend),
      datasetLoader: DatasetLoader(),
      reminders: reminders,
      analytics: analytics,
      today: () => this.today,
      linkLauncher: (uri) async {
        opened.add(uri);
        return true;
      },
    );
  }

  final MemoryStoreBackend backend;
  LocalDate today;
  final reminders = FakeReminderScheduler();
  final analytics = RecordingAnalyticsSink();
  final opened = <Uri>[];
  late final AppController controller;
}
