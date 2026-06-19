import 'package:flutter/material.dart';

import '../../domain/blend_solver.dart';
import '../../domain/feed_catalog.dart';
import '../../domain/flock_profiles.dart';
import '../../domain/nutrient_tint.dart';
import '../../state/ration_scope.dart';
import '../../theme/lab_palette.dart';
import '../../theme/lab_type.dart';
import '../../widgets/bar_meter.dart';
import '../../widgets/gauge_ring.dart';
import '../../widgets/lab_card.dart';
import '../../widgets/solve_button.dart';
import '../../widgets/spec_badge.dart';

class RationCalculatorView extends StatefulWidget {
  const RationCalculatorView({super.key});

  @override
  State<RationCalculatorView> createState() => _RationCalculatorViewState();
}

class _RationCalculatorViewState extends State<RationCalculatorView> {
  FlockProfile _profile = FlockProfiles.all.first;

  String _energyId = 'maize';
  String _proteinId = 'soybean';
  double _proteinShare = 24;
  double _limestone = 8;
  double _methionine = 0.2;

  List<BlendPart> _parts() {
    final energyShare =
        (100 - _proteinShare - _limestone - _methionine).clamp(0, 100);
    return [
      BlendPart(_energyId, energyShare.toDouble()),
      BlendPart(_proteinId, _proteinShare),
      if (_limestone > 0) BlendPart('limestone', _limestone),
      if (_methionine > 0) BlendPart('dlmet', _methionine),
    ];
  }

  Future<void> _save(BlendProfile blend) async {
    final repo = RationScope.of(context);
    await repo.add(
      name: '${_profile.label} mix',
      flockProfileId: _profile.id,
      parts: _parts(),
      costPerKg: blend.costPerKg,
      proteinPct: blend.proteinPct,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ration saved to your workbook.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final parts = _parts();
    final blend = BlendSolver.profileOf(parts);
    final checks = BlendSolver.compliance(blend, _profile.target);
    final onSpec = BlendSolver.meetsSpec(blend, _profile.target);
    final energyShare = parts.first.sharePct;

    final repo = RationScope.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        if (repo.totalRations > 0) ...[
          _workbookCard(repo.totalRations, repo.cheapestCostPerKg),
          const SizedBox(height: 16),
        ],
        _profilePicker(),
        const SizedBox(height: 16),
        LabCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ingredients', style: LabType.heading()),
              const SizedBox(height: 4),
              Text('Pick a cereal and a protein meal, then tune the blend.',
                  style: LabType.body()),
              const SizedBox(height: 16),
              _picker('Energy cereal', FeedCatalog.energyStuffs(), _energyId,
                  (id) => setState(() => _energyId = id)),
              const SizedBox(height: 12),
              _picker('Protein meal', FeedCatalog.proteinStuffs(), _proteinId,
                  (id) => setState(() => _proteinId = id)),
              const SizedBox(height: 18),
              _slider('Protein meal share', _proteinShare, 5, 40, '%',
                  (v) => setState(() => _proteinShare = v)),
              _slider('Limestone share', _limestone, 0, 12, '%',
                  (v) => setState(() => _limestone = v)),
              _slider('DL-methionine', _methionine, 0, 0.5, '%',
                  (v) => setState(() => _methionine = v),
                  divisions: 50),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Energy cereal fills',
                      style: LabType.body(color: LabPalette.slate)),
                  const Spacer(),
                  Text('${energyShare.toStringAsFixed(1)} %',
                      style: LabType.figure(14, color: LabPalette.ink)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _resultCard(blend, checks, onSpec),
        const SizedBox(height: 16),
        SolveButton(
          label: 'Save ration',
          icon: Icons.bookmark_add_outlined,
          onPressed: () => _save(blend),
        ),
        const SizedBox(height: 14),
        Text(
          'Nutrient values are estimates from standard feed tables and are intended for planning, not veterinary formulation.',
          style: LabType.caption(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _workbookCard(int count, double cheapest) {
    final ref = 0.55;
    final frac = cheapest <= 0 ? 0.0 : (1 - (cheapest / ref)).clamp(0.0, 1.0);
    return LabCard(
      child: Row(
        children: [
          GaugeRing(
            size: 78,
            progress: frac,
            stroke: 9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$count', style: LabType.figure(20)),
                Text('saved', style: LabType.caption()),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your workbook', style: LabType.heading()),
                const SizedBox(height: 6),
                Text('Cheapest saved blend',
                    style: LabType.caption()),
                const SizedBox(height: 2),
                Text('\$${cheapest.toStringAsFixed(3)} /kg',
                    style: LabType.readout(18, color: LabPalette.limeDeep)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profilePicker() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: FlockProfiles.all.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final p = FlockProfiles.all[i];
          final selected = p.id == _profile.id;
          return GestureDetector(
            onTap: () => setState(() => _profile = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? LabPalette.limeDeep : LabPalette.panel,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? LabPalette.limeDeep : LabPalette.rule,
                ),
              ),
              child: Text(p.label,
                  style: LabType.label(
                      color: selected ? Colors.white : LabPalette.slate)),
            ),
          );
        },
      ),
    );
  }

  Widget _picker(String label, List<Feedstuff> options, String selectedId,
      ValueChanged<String> onPick) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: LabType.label()),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((f) {
            final sel = f.id == selectedId;
            return GestureDetector(
              onTap: () => onPick(f.id),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                decoration: BoxDecoration(
                  color: sel ? LabPalette.limeWash : LabPalette.sheet,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: sel ? LabPalette.lime : LabPalette.rule,
                    width: sel ? 1.5 : 1,
                  ),
                ),
                child: Text(f.label,
                    style: LabType.bodyStrong(
                        color: sel ? LabPalette.limeDeep : LabPalette.ink)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _slider(String label, double value, double min, double max,
      String unit, ValueChanged<double> onChanged,
      {int? divisions}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: LabType.bodyStrong())),
              Text('${value.toStringAsFixed(value % 1 == 0 ? 0 : 2)} $unit',
                  style: LabType.figure(13.5, color: LabPalette.limeDeep)),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions ?? (max - min).round(),
            onChanged: (v) =>
                onChanged(double.parse(v.toStringAsFixed(2))),
          ),
        ],
      ),
    );
  }

  Widget _resultCard(
      BlendProfile blend, List<NutrientCheck> checks, bool onSpec) {
    return LabCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Nutrient profile', style: LabType.heading()),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: onSpec
                      ? LabPalette.limeWash
                      : LabPalette.flagWash,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  onSpec ? 'Meets spec' : 'Below spec',
                  style: LabType.label(
                      color: onSpec
                          ? LabPalette.limeDeep
                          : LabPalette.flag),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...checks.map(_checkRow),
          const Divider(height: 28),
          Row(
            children: [
              Text('Blend cost', style: LabType.bodyStrong()),
              const Spacer(),
              Text('\$${blend.costPerKg.toStringAsFixed(3)} /kg',
                  style: LabType.readout(18, color: LabPalette.limeDeep)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkRow(NutrientCheck c) {
    final frac = c.minTarget <= 0
        ? 1.0
        : (c.value / (c.maxTarget ?? c.minTarget * 1.25));
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BarMeter(
                  label: c.label,
                  valueText:
                      '${c.value.toStringAsFixed(c.unit == 'kcal/kg' ? 0 : 2)} ${c.unit}',
                  fraction: frac,
                  color: nutrientTint(c.state),
                ),
              ),
              const SizedBox(width: 12),
              SpecBadge(state: c.state),
            ],
          ),
        ],
      ),
    );
  }
}
