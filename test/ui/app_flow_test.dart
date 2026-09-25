import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newcomer_os/app.dart';
import 'package:newcomer_os/domain/local_date.dart';
import 'package:newcomer_os/domain/user_state.dart';

import '../support/controller.dart';
import '../support/fixtures.dart';

void main() {
  testWidgets('first run: disclaimer → onboarding → checklist', (tester) async {
    final h = await pumpApp(tester);
    expect(
      find.text('Your first 90 days in Germany, step by step'),
      findsOneWidget,
    );
    expect(find.textContaining('not a government service'), findsOneWidget);

    await tapText(tester, 'I understand — start');
    expect(find.text('How did you enter Germany?'), findsOneWidget);
    // Next disabled until an answer is chosen.
    final next = find.widgetWithText(FilledButton, 'Next');
    expect(tester.widget<FilledButton>(next).onPressed, isNull);

    await tapText(tester, 'With a national visa for studies ("D" visa)');
    await tapText(tester, 'Next');
    await tapText(tester, 'A degree programme (Bachelor, Master, PhD)');
    await tapText(tester, 'Next');
    await tapText(tester, 'Berlin');
    await tapText(tester, 'Next');

    // Arrival date via date picker.
    await tapText(tester, 'Choose date');
    await tapText(tester, 'OK');
    await tapText(tester, 'Next');
    await tapText(tester, "I don't have a long-term home yet");
    await tapText(tester, 'Next');
    await tapText(tester, "I'll add it later");
    await tapText(tester, 'Next');
    await tapText(tester, 'I plan to work while studying');
    await tapText(tester, 'Next');

    expect(find.text('Your checklist is ready'), findsOneWidget);
    await tapText(tester, 'See my checklist');

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(
      find.text('Get the landlord confirmation for your address'),
      findsOneWidget,
    );
    expect(h.controller.profile!.plansToWork, isTrue);
    expect(h.controller.profile!.moveInDate, isNull);
  });

  testWidgets('task detail shows source metadata and completes task', (
    tester,
  ) async {
    final h = Harness();
    await tester.runAsync(() async {
      await h.controller.init();
      await h.controller.acceptDisclaimer();
      await h.controller.completeOnboarding(
        profile(moveIn: LocalDate(2026, 10, 1)),
      );
    });
    await pumpApp(tester, harness: h);

    await tapText(tester, 'Get the landlord confirmation for your address');
    await revealText(tester, 'Legal deadline (from the law');
    await revealText(tester, 'Official source');
    expect(find.text('Official source'), findsOneWidget);
    await revealText(tester, 'Bundesmeldegesetz (BMG) § 19');
    await revealText(tester, 'Last checked by us');

    await tapText(tester, 'Open official page');
    expect(h.opened.single.host, 'www.gesetze-im-internet.de');

    await tapText(tester, 'Mark as done');
    expect(find.text('Mark as not done'), findsOneWidget);
    expect(
      h.controller.state.completions.keys,
      contains('de.housing.landlord_confirmation'),
    );
  });

  testWidgets('German UI and German content', (tester) async {
    final h = Harness();
    await tester.runAsync(() async {
      await h.controller.init();
      await h.controller.acceptDisclaimer();
      await h.controller.completeOnboarding(profile());
      await h.controller.setLanguage(LanguagePreference.de);
    });
    await pumpApp(tester, harness: h);
    expect(find.text('Heute'), findsOneWidget);
    expect(
      find.text('Wohnungsgeberbestätigung für Ihre Adresse holen'),
      findsOneWidget,
    );
  });

  testWidgets('empty Done tab explains itself', (tester) async {
    final h = Harness();
    await tester.runAsync(() async {
      await h.controller.init();
      await h.controller.acceptDisclaimer();
      await h.controller.completeOnboarding(profile());
    });
    await pumpApp(tester, harness: h);
    await tapText(tester, 'Done');
    expect(find.text('Tasks you mark as done appear here.'), findsOneWidget);
  });

  testWidgets('settings: delete all data returns to welcome', (tester) async {
    final h = Harness();
    await tester.runAsync(() async {
      await h.controller.init();
      await h.controller.acceptDisclaimer();
      await h.controller.completeOnboarding(profile());
    });
    await pumpApp(tester, harness: h);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tapText(tester, 'Delete all my data');
    await tapText(tester, 'Delete');
    expect(
      find.text('Your first 90 days in Germany, step by step'),
      findsOneWidget,
    );
  });

  testWidgets('large text does not overflow key screens', (tester) async {
    final h = Harness();
    await tester.runAsync(() async {
      await h.controller.init();
      await h.controller.acceptDisclaimer();
      await h.controller.completeOnboarding(profile(work: true));
    });
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpApp(tester, harness: h);
    expect(tester.takeException(), isNull);
    await tapText(tester, 'Get the landlord confirmation for your address');
    expect(tester.takeException(), isNull);
  });

  testWidgets('meets tap-target and labelling guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    final h = Harness();
    await tester.runAsync(() async {
      await h.controller.init();
      await h.controller.acceptDisclaimer();
      await h.controller.completeOnboarding(profile());
    });
    await pumpApp(tester, harness: h);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}

Future<Harness> pumpApp(WidgetTester tester, {Harness? harness}) async {
  final h = harness ?? Harness();
  await tester.runAsync(h.controller.init);
  await tester.pumpWidget(ErstmalApp(controller: h.controller));
  await tester.pumpAndSettle();
  return h;
}

Future<void> tapText(WidgetTester tester, String text) async {
  await reveal(tester, find.text(text));
  await tester.tap(find.text(text).first);
  await tester.pumpAndSettle();
}

Future<void> revealText(WidgetTester tester, String text) =>
    reveal(tester, find.textContaining(text));

Future<void> reveal(WidgetTester tester, Finder finder) async {
  // Lazily built lists only create visible children: scroll to find it.
  for (var i = 0; i < 30 && finder.evaluate().isEmpty; i++) {
    final vertical = find.byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    );
    await tester.drag(vertical.last, const Offset(0, -300));
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
}
