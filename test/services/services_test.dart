import 'package:flutter_test/flutter_test.dart';
import 'package:newcomer_os/services/link_service.dart';
import 'package:newcomer_os/services/reminder_service.dart';

import '../support/fixtures.dart';

void main() {
  group('LinkService', () {
    final opened = <Uri>[];
    final ds = loadRealDataset();
    final service = LinkService.forDataset(
      ds,
      launcher: (uri) async {
        opened.add(uri);
        return true;
      },
    );

    test('opens dataset https links', () async {
      final url = ds.sources.values.first.url;
      expect(await service.open(url), LinkOpenResult.opened);
      expect(opened.last.toString(), url);
    });

    test('rejects anything not in the dataset', () async {
      for (final url in [
        'https://evil.example.com/',
        'http://www.gesetze-im-internet.de/bmg/__17.html',
        'javascript:alert(1)',
        'intent://x',
        '',
      ]) {
        expect(await service.open(url), LinkOpenResult.rejected, reason: url);
      }
    });

    test('reports failure when no browser can open it', () async {
      final failing = LinkService.forDataset(ds, launcher: (_) async => false);
      expect(
        await failing.open(ds.sources.values.first.url),
        LinkOpenResult.failed,
      );
      final throwing = LinkService.forDataset(
        ds,
        launcher: (_) => throw Exception('x'),
      );
      expect(
        await throwing.open(ds.sources.values.first.url),
        LinkOpenResult.failed,
      );
    });
  });

  test('notification ids are stable, positive and distinct per rule', () {
    final ids = loadRealDataset().rules.map((r) => notificationIdFor(r.id));
    expect(ids.toSet().length, ids.length);
    expect(ids.every((id) => id > 0 && id <= 0x7fffffff), isTrue);
    expect(
      notificationIdFor('de.registration.anmeldung'),
      notificationIdFor('de.registration.anmeldung'),
    );
  });
}
