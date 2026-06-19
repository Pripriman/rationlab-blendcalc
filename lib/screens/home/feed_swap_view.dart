import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/feed_catalog.dart';
import '../../theme/lab_palette.dart';
import '../../theme/lab_type.dart';
import '../../widgets/lab_card.dart';

class FeedSwapView extends StatefulWidget {
  const FeedSwapView({super.key});

  @override
  State<FeedSwapView> createState() => _FeedSwapViewState();
}

class _FeedSwapViewState extends State<FeedSwapView> {
  Feedstuff _base = FeedCatalog.byId('soybean');

  List<Feedstuff> get _alternatives {
    final same = FeedCatalog.all
        .where((f) => f.category == _base.category && f.id != _base.id)
        .toList()
      ..sort((a, b) => a.pricePerKg.compareTo(b.pricePerKg));
    return same;
  }

  @override
  Widget build(BuildContext context) {
    final alts = _alternatives;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      children: [
        LabCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Find a cheaper feedstuff', style: LabType.heading()),
              const SizedBox(height: 4),
              Text(
                'Pick an ingredient to see lower-cost options in the same category and how their nutrition compares.',
                style: LabType.body(),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FeedCatalog.all
                    .where((f) =>
                        f.category == 'Protein' || f.category == 'Energy')
                    .map((f) {
                  final sel = f.id == _base.id;
                  return GestureDetector(
                    onTap: () => setState(() => _base = f),
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
                      child: Text(f.label,
                          style: LabType.bodyStrong(
                              color: sel
                                  ? LabPalette.limeDeep
                                  : LabPalette.ink)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _baseCard(),
        const SizedBox(height: 16),
        Text('Cheaper in “${_base.category}”', style: LabType.label()),
        const SizedBox(height: 10),
        if (alts.isEmpty)
          LabCard(
            child: Text('No cheaper option found in this category.',
                style: LabType.body()),
          )
        else
          ...alts.map(_altCard),
        const SizedBox(height: 14),
        Text(
          'Substitutions must keep the ration within nutrient spec; check the balanced result in the ration calculator.',
          style: LabType.caption(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _baseCard() {
    return LabCard(
      color: LabPalette.sheetDeep,
      border: Border.all(color: LabPalette.rule),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_base.label, style: LabType.heading()),
                const SizedBox(height: 4),
                Text(
                    '${_base.proteinPct.toStringAsFixed(0)}% protein · ${_base.energyKcalPerKg.toStringAsFixed(0)} kcal/kg',
                    style: LabType.caption()),
              ],
            ),
          ),
          Text('\$${_base.pricePerKg.toStringAsFixed(2)}',
              style: LabType.readout(20, color: LabPalette.ink)),
          Text(' /kg', style: LabType.caption()),
        ],
      ),
    );
  }

  Widget _altCard(Feedstuff alt) {
    final saving = _base.pricePerKg - alt.pricePerKg;
    final savingPct =
        _base.pricePerKg <= 0 ? 0.0 : (saving / _base.pricePerKg) * 100;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: LabCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(alt.label, style: LabType.bodyStrong()),
                ),
                Text('\$${alt.pricePerKg.toStringAsFixed(2)} /kg',
                    style: LabType.readout(15, color: LabPalette.ink)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  saving > 0
                      ? Icons.trending_down_rounded
                      : Icons.trending_up_rounded,
                  size: 15,
                  color: saving > 0 ? LabPalette.limeDeep : LabPalette.amber,
                ),
                const SizedBox(width: 6),
                Text(
                  saving > 0
                      ? 'Saves \$${saving.toStringAsFixed(2)}/kg (${savingPct.toStringAsFixed(0)}%)'
                      : '${(-savingPct).toStringAsFixed(0)}% dearer per kg',
                  style: LabType.caption(
                      color: saving > 0
                          ? LabPalette.limeDeep
                          : LabPalette.amber),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(height: 96, child: _compareChart(alt)),
            const SizedBox(height: 6),
            Text(alt.note, style: LabType.caption()),
          ],
        ),
      ),
    );
  }

  Widget _compareChart(Feedstuff alt) {
    BarChartGroupData group(int x, double base, double altVal, double scale) {
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: base / scale,
            color: LabPalette.slateFaint,
            width: 9,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: altVal / scale,
            color: LabPalette.limeDeep,
            width: 9,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 1.2,
        barTouchData: BarTouchData(enabled: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ['Protein', 'Energy', 'Lysine'];
                final i = value.toInt();
                if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(labels[i], style: LabType.caption()),
                );
              },
            ),
          ),
        ),
        barGroups: [
          group(0, _base.proteinPct, alt.proteinPct, 60),
          group(1, _base.energyKcalPerKg, alt.energyKcalPerKg, 3500),
          group(2, _base.lysinePct, alt.lysinePct, 5),
        ],
      ),
    );
  }
}
