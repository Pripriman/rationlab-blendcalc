import 'feed_catalog.dart';
import 'flock_profiles.dart';

class BlendPart {
  final String feedId;
  final double sharePct;
  const BlendPart(this.feedId, this.sharePct);
}

class BlendProfile {
  final double proteinPct;
  final double energyKcalPerKg;
  final double lysinePct;
  final double methioninePct;
  final double calciumPct;
  final double costPerKg;

  const BlendProfile({
    required this.proteinPct,
    required this.energyKcalPerKg,
    required this.lysinePct,
    required this.methioninePct,
    required this.calciumPct,
    required this.costPerKg,
  });
}

enum NutrientState { underrun, withinSpec, overrun }

class NutrientCheck {
  final String label;
  final String unit;
  final double value;
  final double minTarget;
  final double? maxTarget;
  final NutrientState state;

  const NutrientCheck({
    required this.label,
    required this.unit,
    required this.value,
    required this.minTarget,
    required this.maxTarget,
    required this.state,
  });
}

class BlendSolver {
  static BlendProfile profileOf(List<BlendPart> parts) {
    var protein = 0.0;
    var energy = 0.0;
    var lysine = 0.0;
    var methionine = 0.0;
    var calcium = 0.0;
    var cost = 0.0;
    for (final part in parts) {
      final feed = FeedCatalog.byId(part.feedId);
      final frac = part.sharePct / 100.0;
      protein += feed.proteinPct * frac;
      energy += feed.energyKcalPerKg * frac;
      lysine += feed.lysinePct * frac;
      methionine += feed.methioninePct * frac;
      calcium += feed.calciumPct * frac;
      cost += feed.pricePerKg * frac;
    }
    return BlendProfile(
      proteinPct: protein,
      energyKcalPerKg: energy,
      lysinePct: lysine,
      methioninePct: methionine,
      calciumPct: calcium,
      costPerKg: cost,
    );
  }

  static double totalShare(List<BlendPart> parts) {
    var sum = 0.0;
    for (final part in parts) {
      sum += part.sharePct;
    }
    return sum;
  }

  static List<NutrientCheck> compliance(
    BlendProfile blend,
    NutrientTarget target,
  ) {
    return [
      _check('Protein', '%', blend.proteinPct, target.minProteinPct, null),
      _check('Energy', 'kcal/kg', blend.energyKcalPerKg,
          target.minEnergyKcalPerKg, null),
      _check('Lysine', '%', blend.lysinePct, target.minLysinePct, null),
      _check('Methionine', '%', blend.methioninePct, target.minMethioninePct,
          null),
      _check('Calcium', '%', blend.calciumPct, target.minCalciumPct,
          target.maxCalciumPct),
    ];
  }

  static NutrientCheck _check(
    String label,
    String unit,
    double value,
    double minTarget,
    double? maxTarget,
  ) {
    NutrientState state;
    if (value < minTarget * 0.995) {
      state = NutrientState.underrun;
    } else if (maxTarget != null && value > maxTarget * 1.005) {
      state = NutrientState.overrun;
    } else {
      state = NutrientState.withinSpec;
    }
    return NutrientCheck(
      label: label,
      unit: unit,
      value: value,
      minTarget: minTarget,
      maxTarget: maxTarget,
      state: state,
    );
  }

  static bool meetsSpec(BlendProfile blend, NutrientTarget target) {
    return compliance(blend, target)
        .every((c) => c.state == NutrientState.withinSpec);
  }

  static double costPerDayPerHen(BlendProfile blend, FlockProfile profile) {
    return blend.costPerKg * (profile.intakeGramsPerDay / 1000.0);
  }

  static double costPerEgg(BlendProfile blend, FlockProfile profile) {
    if (profile.eggsPerHenPerMonth <= 0) return 0;
    final monthlyFeed =
        costPerDayPerHen(blend, profile) * 30.0;
    return monthlyFeed / profile.eggsPerHenPerMonth;
  }

  static List<BlendPart> solveLeastCost(FlockProfile profile) {
    final target = profile.target;
    final candidates = <List<BlendPart>>[];

    for (final energy in FeedCatalog.energyStuffs()) {
      for (final protein in FeedCatalog.proteinStuffs()) {
        for (var pShare = 8.0; pShare <= 36.0; pShare += 2.0) {
          for (var ca = 0.0; ca <= 9.0; ca += 1.0) {
            final met = 0.18;
            final eShare = 100.0 - pShare - ca - met;
            if (eShare < 35) continue;
            if (pShare > protein.maxInclusionPct) continue;
            if (eShare > energy.maxInclusionPct) continue;
            final parts = <BlendPart>[
              BlendPart(energy.id, eShare),
              BlendPart(protein.id, pShare),
              if (ca > 0) BlendPart('limestone', ca),
              BlendPart('dlmet', met),
            ];
            final blend = profileOf(parts);
            if (!meetsSpec(blend, target)) continue;
            candidates.add(parts);
          }
        }
      }
    }

    if (candidates.isEmpty) return const [];
    candidates.sort((a, b) =>
        profileOf(a).costPerKg.compareTo(profileOf(b).costPerKg));
    return candidates.first;
  }
}
