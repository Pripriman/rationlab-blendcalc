import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/flock_profiles.dart';
import '../../theme/lab_palette.dart';
import '../../theme/lab_type.dart';
import '../../widgets/lab_card.dart';
import '../../widgets/stepper_field.dart';

class CostPerEggView extends StatefulWidget {
  const CostPerEggView({super.key});

  @override
  State<CostPerEggView> createState() => _CostPerEggViewState();
}

class _CostPerEggViewState extends State<CostPerEggView> {
  FlockProfile _profile =
      FlockProfiles.all.firstWhere((p) => p.purpose == 'Eggs');

  double _costPerKg = 0.34;
  late double _intake;
  late double _eggs;
  double _sellPrice = 0.18;

  @override
  void initState() {
    super.initState();
    _intake = _profile.intakeGramsPerDay;
    _eggs = _profile.eggsPerHenPerMonth;
  }

  void _applyProfile(FlockProfile p) {
    setState(() {
      _profile = p;
      _intake = p.intakeGramsPerDay;
      _eggs = p.eggsPerHenPerMonth == 0 ? 22 : p.eggsPerHenPerMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final feedPerDay = _costPerKg * (_intake / 1000.0);
    final monthlyFeed = feedPerDay * 30.0;
    final costPerEgg = _eggs <= 0 ? 0.0 : monthlyFeed / _eggs;
    final marginPerEgg = _sellPrice - costPerEgg;

    final layers =
        FlockProfiles.all.where((p) => p.purpose == 'Eggs').toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: layers.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final p = layers[i];
              final selected = p.id == _profile.id;
              return GestureDetector(
                onTap: () => _applyProfile(p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? LabPalette.limeDeep : LabPalette.panel,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          selected ? LabPalette.limeDeep : LabPalette.rule,
                    ),
                  ),
                  child: Text(p.label,
                      style: LabType.label(
                          color:
                              selected ? Colors.white : LabPalette.slate)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        LabCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Inputs', style: LabType.heading()),
              const SizedBox(height: 14),
              _slider('Feed cost', _costPerKg, 0.15, 0.80, '\$/kg',
                  (v) => setState(() => _costPerKg = v), divisions: 65),
              const SizedBox(height: 6),
              StepperField(
                label: 'Daily intake',
                value: _intake,
                step: 1,
                min: 40,
                max: 200,
                unit: 'g',
                onChanged: (v) => setState(() => _intake = v),
              ),
              const Divider(height: 24),
              StepperField(
                label: 'Eggs / hen / month',
                value: _eggs,
                step: 1,
                min: 0,
                max: 31,
                onChanged: (v) => setState(() => _eggs = v),
              ),
              const Divider(height: 24),
              _slider('Egg sale price', _sellPrice, 0.05, 0.40, '\$/egg',
                  (v) => setState(() => _sellPrice = v), divisions: 70),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _resultCard(costPerEgg, monthlyFeed, marginPerEgg, costPerEgg),
        const SizedBox(height: 14),
        Text(
          'Estimates assume steady intake and lay rate; real costs vary with flock health, season and waste.',
          style: LabType.caption(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _resultCard(double costPerEgg, double monthlyFeed,
      double margin, double feedShareCost) {
    final marginPositive = margin >= 0;
    final feedFrac =
        _sellPrice <= 0 ? 1.0 : (feedShareCost / _sellPrice).clamp(0.0, 1.0);
    return LabCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Result', style: LabType.heading()),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: _donut(feedFrac),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Feed cost per egg', style: LabType.caption()),
                    const SizedBox(height: 4),
                    Text('\$${costPerEgg.toStringAsFixed(3)}',
                        style:
                            LabType.readout(26, color: LabPalette.limeDeep)),
                    const SizedBox(height: 14),
                    Text('Margin per egg', style: LabType.caption()),
                    const SizedBox(height: 4),
                    Text(
                      '${margin >= 0 ? '+' : '-'}\$${margin.abs().toStringAsFixed(3)}',
                      style: LabType.readout(20,
                          color: marginPositive
                              ? LabPalette.withinSpec
                              : LabPalette.flag),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          Row(
            children: [
              Text('Monthly feed / hen', style: LabType.bodyStrong()),
              const Spacer(),
              Text('\$${monthlyFeed.toStringAsFixed(2)}',
                  style: LabType.readout(16, color: LabPalette.ink)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _donut(double feedFrac) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            startDegreeOffset: -90,
            sectionsSpace: 2,
            centerSpaceRadius: 34,
            sections: [
              PieChartSectionData(
                value: feedFrac,
                color: LabPalette.limeDeep,
                radius: 16,
                showTitle: false,
              ),
              PieChartSectionData(
                value: (1 - feedFrac).clamp(0.0, 1.0),
                color: LabPalette.sheetDeep,
                radius: 16,
                showTitle: false,
              ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${(feedFrac * 100).toStringAsFixed(0)}%',
                style: LabType.figure(18)),
            Text('feed', style: LabType.caption()),
          ],
        ),
      ],
    );
  }

  Widget _slider(String label, double value, double min, double max,
      String unit, ValueChanged<double> onChanged,
      {int? divisions}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: LabType.bodyStrong())),
            Text('${value.toStringAsFixed(2)} $unit',
                style: LabType.figure(13.5, color: LabPalette.limeDeep)),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions ?? (max - min).round(),
          onChanged: (v) => onChanged(double.parse(v.toStringAsFixed(3))),
        ),
      ],
    );
  }
}
