import 'package:flutter/material.dart';

import '../../domain/local_date.dart';
import '../../domain/profile.dart';
import '../../domain/roadmap_resolver.dart';
import '../../domain/dataset.dart';
import '../../l10n/gen/app_localizations.dart';
import '../../state/app_scope.dart';
import '../format.dart';

enum _Step { entry, stage, city, arrival, moveIn, visa, more, summary }

/// Asks only the questions needed to select rules. Used for first-run
/// onboarding and (with [initial]) for editing answers later.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.initial});

  final UserProfile? initial;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late EntryType? _entry = widget.initial?.entryType;
  late StudyStage? _stage = widget.initial?.studyStage;
  late City? _city = widget.initial?.city;
  late LocalDate? _arrival = widget.initial?.arrivalDate;
  late LocalDate? _moveIn = widget.initial?.moveInDate;
  late bool _moveInUnknown =
      widget.initial != null && widget.initial!.moveInDate == null;
  late LocalDate? _visaExpiry = widget.initial?.visaExpiryDate;
  late bool _visaUnknown =
      widget.initial != null && widget.initial!.visaExpiryDate == null;
  late LocalDate? _permitExpiry = widget.initial?.permitExpiryDate;
  late bool _age30 = widget.initial?.age30Plus ?? false;
  late bool _work = widget.initial?.plansToWork ?? false;
  late bool _family = widget.initial?.familyJoining ?? false;
  int _index = 0;

  bool get _editing => widget.initial != null;

  List<_Step> get _steps => [
    _Step.entry,
    _Step.stage,
    _Step.city,
    _Step.arrival,
    _Step.moveIn,
    if (_entry == EntryType.nationalVisa) _Step.visa,
    _Step.more,
    _Step.summary,
  ];

  _Step get _current => _steps[_index.clamp(0, _steps.length - 1)];

  bool get _canContinue => switch (_current) {
    _Step.entry => _entry != null,
    _Step.stage => _stage != null,
    _Step.city => _city != null,
    _Step.arrival => _arrival != null,
    _Step.moveIn => _moveIn != null || _moveInUnknown,
    _Step.visa => _visaExpiry != null || _visaUnknown,
    _Step.more || _Step.summary => true,
  };

  UserProfile _draft() => UserProfile(
    entryType: _entry!,
    studyStage: _stage!,
    city: _city!,
    arrivalDate: _arrival!,
    moveInDate: _moveInUnknown ? null : _moveIn,
    visaExpiryDate: _entry == EntryType.nationalVisa && !_visaUnknown
        ? _visaExpiry
        : null,
    permitExpiryDate: _entry == EntryType.euEeaCh ? null : _permitExpiry,
    age30Plus: _age30,
    plansToWork: _work,
    familyJoining: _family,
  );

  Future<void> _finish() async {
    await AppScope.read(context).completeOnboarding(_draft());
    if (_editing && mounted) Navigator.of(context).pop();
  }

  void _next() {
    if (_current == _Step.summary) {
      _finish();
    } else {
      setState(() => _index++);
    }
  }

  Future<LocalDate?> _pickDate(LocalDate? initial) async {
    final today = AppScope.read(context).today;
    final base = initial ?? today;
    final picked = await showDatePicker(
      context: context,
      initialDate: base.atTime(12),
      firstDate: today.addDays(-3 * 365).atTime(0),
      lastDate: today.addDays(5 * 365).atTime(0),
    );
    return picked == null ? null : LocalDate.fromDateTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final questionCount = _steps.length - 1;
    return PopScope(
      canPop: _editing || _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _index > 0) setState(() => _index--);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editing ? l.editAnswers : l.appTitle),
          leading: _index > 0
              ? IconButton(
                  tooltip: l.back,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _index--),
                )
              : null,
          automaticallyImplyLeading: _editing,
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (_current != _Step.summary)
                Semantics(
                  label: l.stepOf(_index + 1, questionCount),
                  child: LinearProgressIndicator(
                    value: (_index + 1) / questionCount,
                  ),
                ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    if (_current != _Step.summary)
                      Text(
                        l.stepOf(_index + 1, questionCount),
                        style: theme.textTheme.labelLarge,
                      ),
                    const SizedBox(height: 8),
                    ..._body(context, l),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _canContinue ? _next : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _current == _Step.summary
                            ? (_editing ? l.saveAnswers : l.seeChecklist)
                            : l.next,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _body(BuildContext context, AppLocalizations l) {
    switch (_current) {
      case _Step.entry:
        return [
          _Question(title: l.qEntryTitle, why: l.qEntryWhy),
          _Choices<EntryType>(
            value: _entry,
            onChanged: (v) => setState(() => _entry = v),
            options: {
              EntryType.nationalVisa: l.entryNationalVisa,
              EntryType.visaFree: l.entryVisaFree,
              EntryType.euEeaCh: l.entryEu,
            },
          ),
          _Help(l.entryHelp),
        ];
      case _Step.stage:
        return [
          _Question(title: l.qStageTitle, why: l.qStageWhy),
          _Choices<StudyStage>(
            value: _stage,
            onChanged: (v) => setState(() => _stage = v),
            options: {
              StudyStage.degree: l.stageDegree,
              StudyStage.preparatory: l.stagePrep,
            },
          ),
        ];
      case _Step.city:
        return [
          _Question(title: l.qCityTitle, why: l.qCityWhy),
          _Choices<City>(
            value: _city,
            onChanged: (v) => setState(() => _city = v),
            options: {
              City.berlin: l.cityBerlin,
              City.munich: l.cityMunich,
              City.other: l.cityOther,
            },
          ),
          if (_city == City.other) _Help(l.cityOtherHelp),
        ];
      case _Step.arrival:
        return [
          _Question(title: l.qArrivalTitle, why: l.qArrivalWhy),
          _DateField(
            value: _arrival,
            onPick: () async {
              final d = await _pickDate(_arrival);
              if (d != null) setState(() => _arrival = d);
            },
          ),
        ];
      case _Step.moveIn:
        return [
          _Question(title: l.qMoveInTitle, why: l.qMoveInWhy),
          _DateField(
            value: _moveInUnknown ? null : _moveIn,
            onPick: () async {
              final d = await _pickDate(_moveIn ?? _arrival);
              if (d != null) {
                setState(() {
                  _moveIn = d;
                  _moveInUnknown = false;
                });
              }
            },
          ),
          CheckboxListTile(
            value: _moveInUnknown,
            onChanged: (v) => setState(() => _moveInUnknown = v ?? false),
            title: Text(l.moveInUnknown),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ];
      case _Step.visa:
        return [
          _Question(title: l.qVisaTitle, why: l.qVisaWhy),
          _Help(l.visaHelp),
          _DateField(
            value: _visaUnknown ? null : _visaExpiry,
            onPick: () async {
              final d = await _pickDate(_visaExpiry ?? _arrival);
              if (d != null) {
                setState(() {
                  _visaExpiry = d;
                  _visaUnknown = false;
                });
              }
            },
          ),
          CheckboxListTile(
            value: _visaUnknown,
            onChanged: (v) => setState(() => _visaUnknown = v ?? false),
            title: Text(l.visaUnknown),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ];
      case _Step.more:
        return [
          _Question(title: l.qMoreTitle, why: l.qMoreWhy),
          SwitchListTile(
            value: _age30,
            onChanged: (v) => setState(() => _age30 = v),
            title: Text(l.age30Plus),
            subtitle: Text(l.age30PlusHelp),
          ),
          SwitchListTile(
            value: _work,
            onChanged: (v) => setState(() => _work = v),
            title: Text(l.plansToWork),
          ),
          SwitchListTile(
            value: _family,
            onChanged: (v) => setState(() => _family = v),
            title: Text(l.familyJoining),
          ),
          if (_editing && _entry != EntryType.euEeaCh) ...[
            const Divider(height: 32),
            Text(
              l.permitExpiryLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            _DateField(
              value: _permitExpiry,
              onPick: () async {
                final d = await _pickDate(_permitExpiry);
                if (d != null) setState(() => _permitExpiry = d);
              },
            ),
          ],
        ];
      case _Step.summary:
        final controller = AppScope.read(context);
        final roadmap = const RoadmapResolver().resolve(
          dataset: controller.dataset,
          profile: _draft(),
          state: controller.state,
          today: controller.today,
          language: contentLanguage(context),
        );
        return [
          Icon(
            Icons.checklist,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Semantics(
            header: true,
            child: Text(
              l.summaryTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 8),
          Text(l.summaryBody(roadmap.totalCount)),
          if (_entry == EntryType.euEeaCh) ...[
            const SizedBox(height: 16),
            _Help(l.euNotice),
          ],
          const SizedBox(height: 16),
          _Help(l.welcomePrivacy),
          const SizedBox(height: 8),
          for (final task in roadmap.tasks.where(
            (t) =>
                t.rule.timing.type != TimingType.event &&
                t.bucket != TaskBucket.done,
          ))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ExcludeSemantics(
                    child: Icon(Icons.radio_button_unchecked, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(task.content.title)),
                ],
              ),
            ),
        ];
    }
  }
}

class _Question extends StatelessWidget {
  const _Question({required this.title, required this.why});
  final String title;
  final String why;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(title, style: theme.textTheme.headlineSmall),
          ),
          const SizedBox(height: 8),
          Text(
            '${l.whyWeAsk}: $why',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Help extends StatelessWidget {
  const _Help(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExcludeSemantics(child: Icon(Icons.info_outline, size: 20)),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _Choices<T> extends StatelessWidget {
  const _Choices({
    required this.value,
    required this.onChanged,
    required this.options,
  });

  final T? value;
  final ValueChanged<T> onChanged;
  final Map<T, String> options;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: value,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      child: Column(
        children: [
          for (final entry in options.entries)
            RadioListTile<T>(value: entry.key, title: Text(entry.value)),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.value, required this.onPick});
  final LocalDate? value;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: OutlinedButton.icon(
        onPressed: onPick,
        icon: const Icon(Icons.calendar_today),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            value == null
                ? l.pickDate
                : '${formatDate(context, value!)} · ${l.changeDate}',
          ),
        ),
      ),
    );
  }
}
