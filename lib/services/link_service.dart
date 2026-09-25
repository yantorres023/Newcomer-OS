import 'package:url_launcher/url_launcher.dart';

import '../domain/dataset.dart';

enum LinkOpenResult { opened, rejected, failed }

/// Opens official source links.
///
/// Only `https` URLs that appear in the bundled dataset can be opened. This
/// prevents the app from being used to open arbitrary URLs (e.g. from a
/// crafted deep link or a tampered note) and guarantees users are never
/// silently sent to an unofficial substitute.
class LinkService {
  LinkService(this._allowedUrls, {LinkLauncher? launcher})
    : _launcher = launcher ?? _defaultLauncher;

  factory LinkService.forDataset(
    RoadmapDataset dataset, {
    LinkLauncher? launcher,
  }) => LinkService(
    dataset.sources.values.map((s) => s.url).toSet(),
    launcher: launcher,
  );

  final Set<String> _allowedUrls;
  final LinkLauncher _launcher;

  bool isAllowed(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host.isNotEmpty &&
        _allowedUrls.contains(url);
  }

  Future<LinkOpenResult> open(String url) async {
    if (!isAllowed(url)) return LinkOpenResult.rejected;
    try {
      final ok = await _launcher(Uri.parse(url));
      return ok ? LinkOpenResult.opened : LinkOpenResult.failed;
    } on Object {
      return LinkOpenResult.failed;
    }
  }
}

typedef LinkLauncher = Future<bool> Function(Uri uri);

Future<bool> _defaultLauncher(Uri uri) =>
    launchUrl(uri, mode: LaunchMode.externalApplication);
