import 'package:flutter/material.dart';

import '../../domain/blend_solver.dart';
import '../../domain/feed_catalog.dart';
import '../../domain/flock_profiles.dart';
import '../../domain/nutrient_tint.dart';
import '../../state/ration_scope.dart';
import '../../theme/lab_palette.dart';
import '../../theme/lab_type.dart';
import '../../widgets/lab_card.dart';
import '../../widgets/solve_button.dart';
import '../../widgets/spec_badge.dart';

class MixSolverView extends StatefulWidget {
  const MixSolverView({super.key});

  @override
  State<MixSolverView> createState() => _MixSolverViewState();
}

class _MixSolverViewState extends State<MixSolverView> {
  FlockProfile _profile = FlockProfiles.all.first;
  List<BlendPart>? _solution;
  bool _solving = false;
  bool _failed = false;

  Future<void> _solve() async {
    setState(() {
      _solving = true;
      _failed = false;
      _solution = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final parts = BlendSolver.solveLeastCost(_profile);
    if (!mounted) return;
    setState(() {
      _solving = false;
      _solution = parts.isEmpty ? null : parts;
      _failed = parts.isEmpty;
    });
  }

  Future<void> _save() async {
    final parts = _solution;
    if (parts == null) return;
    final blend = BlendSolver.profileOf(parts);
    final repo = RationScope.of(context);
    await repo.add(
      name: 'Least-cost ${_profile.label}',
      flockProfileId: _profile.id,
      parts: parts,
      costPerKg: blend.costPerKg,
      proteinPct: blend.proteinPct,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solved ration saved.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        LabCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Least-cost mix solver', style: LabType.heading()),
              const SizedBox(height: 4),
              Text(
                'Searches ingredient combinations for the cheapest blend that still clears every nutrient minimum.',
                style: LabType.body(),
              ),
              const SizedBox(height: 14),
              Text('Target flock', style: LabType.label()),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FlockProfiles.all.map((p) {
                  final sel = p.id == _profile.id;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _profile = p;
                      _solution = null;
                      _failed = false;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 9),
                      decoration: BoxDecoration(
                        color: sel ? LabPalette.limeWash : LabPalette.sheet,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: sel ? LabPalette.lime : LabPalette.rule,
                          width: sel ? 1.5 : 1,
                        ),
                      ),
                      child: Text(p.label,
                          style: LabType.bodyStrong(
                              color: sel
                                  ? LabPalette.limeDeep
                                  : LabPalette.ink)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SolveButton(
                label: 'Solve least-cost mix',
                icon: Icons.auto_awesome_rounded,
                busy: _solving,
                onPressed: _solving ? null : _solve,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_failed)
          LabCard(
            color: LabPalette.flagWash,
            border: Border.all(color: LabPalette.flag),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: LabPalette.flag),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No mix from the current ingredient set met every target. Try a different flock stage.',
                    style: LabType.bodyStrong(color: LabPalette.ink),
                  ),
                ),
              ],
            ),
          ),
        if (_solution != null) _solutionCard(_solution!),
      ],
    );
  }

  Widget _solutionCard(List<BlendPart> parts) {
    final blend = BlendSolver.profileOf(parts);
    final checks = BlendSolver.compliance(blend, _profile.target);
    final sorted = [...parts]
      ..sort((a, b) => b.sharePct.compareTo(a.sharePct));
    return LabCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Cheapest valid mix', style: LabType.heading()),
              const Spacer(),
              Text('\$${blend.costPerKg.toStringAsFixed(3)} /kg',
                  style: LabType.readout(18, color: LabPalette.limeDeep)),
            ],
          ),
          const SizedBox(height: 16),
          ...sorted.map(_partRow),
          const Divider(height: 26),
          Text('Nutrient check', style: LabType.label()),
          const SizedBox(height: 12),
          ...checks.map(_checkRow),
          const SizedBox(height: 6),
          SolveButton(
            label: 'Save this mix',
            icon: Icons.bookmark_add_outlined,
            onPressed: _save,
          ),
        ],
      ),
    );
  }

  Widget _partRow(BlendPart part) {
    final feed = FeedCatalog.byId(part.feedId);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(feed.label, style: LabType.bodyStrong()),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (part.sharePct / 100).clamp(0, 1),
                minHeight: 8,
                backgroundColor: LabPalette.sheetDeep,
                color: LabPalette.teal,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 56,
            child: Text('${part.sharePct.toStringAsFixed(1)}%',
                textAlign: TextAlign.right,
                style: LabType.figure(13, color: LabPalette.ink)),
          ),
        ],
      ),
    );
  }

  Widget _checkRow(NutrientCheck c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(c.label, style: LabType.bodyStrong()),
          ),
          Expanded(
            child: Text(
              '${c.value.toStringAsFixed(c.unit == 'kcal/kg' ? 0 : 2)} ${c.unit}',
              style: LabType.figure(13, color: LabPalette.slate),
            ),
          ),
          SpecBadge(state: c.state),
        ],
      ),
    );
  }
}
