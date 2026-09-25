import 'package:flutter/material.dart';

/// Calm, neutral palette. Deliberately avoids German state colours and
/// emblems so the app is never mistaken for an official government product.
const _seed = Color(0xFF1B6B5F);

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    cardTheme: const CardThemeData(margin: EdgeInsets.zero),
    listTileTheme: const ListTileThemeData(minVerticalPadding: 12),
  );
}
