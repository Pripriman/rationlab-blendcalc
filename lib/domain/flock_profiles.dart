class NutrientTarget {
  final double minProteinPct;
  final double minEnergyKcalPerKg;
  final double minLysinePct;
  final double minMethioninePct;
  final double minCalciumPct;
  final double maxCalciumPct;

  const NutrientTarget({
    required this.minProteinPct,
    required this.minEnergyKcalPerKg,
    required this.minLysinePct,
    required this.minMethioninePct,
    required this.minCalciumPct,
    required this.maxCalciumPct,
  });
}

class FlockProfile {
  final String id;
  final String label;
  final String purpose;
  final String stage;
  final double intakeGramsPerDay;
  final double eggsPerHenPerMonth;
  final NutrientTarget target;

  const FlockProfile({
    required this.id,
    required this.label,
    required this.purpose,
    required this.stage,
    required this.intakeGramsPerDay,
    required this.eggsPerHenPerMonth,
    required this.target,
  });
}

class FlockProfiles {
  static const List<FlockProfile> all = [
    FlockProfile(
      id: 'layer_peak',
      label: 'Laying hen · peak',
      purpose: 'Eggs',
      stage: 'Peak production (25–45 wk)',
      intakeGramsPerDay: 115,
      eggsPerHenPerMonth: 27,
      target: NutrientTarget(
        minProteinPct: 17.0,
        minEnergyKcalPerKg: 2750,
        minLysinePct: 0.78,
        minMethioninePct: 0.40,
        minCalciumPct: 3.8,
        maxCalciumPct: 4.6,
      ),
    ),
    FlockProfile(
      id: 'layer_late',
      label: 'Laying hen · late',
      purpose: 'Eggs',
      stage: 'Late lay (60+ wk)',
      intakeGramsPerDay: 110,
      eggsPerHenPerMonth: 23,
      target: NutrientTarget(
        minProteinPct: 15.5,
        minEnergyKcalPerKg: 2700,
        minLysinePct: 0.70,
        minMethioninePct: 0.36,
        minCalciumPct: 4.0,
        maxCalciumPct: 4.8,
      ),
    ),
    FlockProfile(
      id: 'pullet',
      label: 'Pullet · grower',
      purpose: 'Rearing',
      stage: 'Grower (8–18 wk)',
      intakeGramsPerDay: 70,
      eggsPerHenPerMonth: 0,
      target: NutrientTarget(
        minProteinPct: 15.0,
        minEnergyKcalPerKg: 2800,
        minLysinePct: 0.65,
        minMethioninePct: 0.32,
        minCalciumPct: 0.9,
        maxCalciumPct: 1.2,
      ),
    ),
    FlockProfile(
      id: 'broiler_grow',
      label: 'Broiler · grower',
      purpose: 'Meat',
      stage: 'Grower (11–24 d)',
      intakeGramsPerDay: 95,
      eggsPerHenPerMonth: 0,
      target: NutrientTarget(
        minProteinPct: 21.0,
        minEnergyKcalPerKg: 3050,
        minLysinePct: 1.15,
        minMethioninePct: 0.50,
        minCalciumPct: 0.85,
        maxCalciumPct: 1.1,
      ),
    ),
    FlockProfile(
      id: 'broiler_finish',
      label: 'Broiler · finisher',
      purpose: 'Meat',
      stage: 'Finisher (25+ d)',
      intakeGramsPerDay: 150,
      eggsPerHenPerMonth: 0,
      target: NutrientTarget(
        minProteinPct: 19.0,
        minEnergyKcalPerKg: 3150,
        minLysinePct: 1.00,
        minMethioninePct: 0.42,
        minCalciumPct: 0.80,
        maxCalciumPct: 1.0,
      ),
    ),
  ];

  static FlockProfile byId(String id) =>
      all.firstWhere((p) => p.id == id, orElse: () => all.first);
}
