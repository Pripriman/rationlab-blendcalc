class Feedstuff {
  final String id;
  final String label;
  final String category;
  final double proteinPct;
  final double energyKcalPerKg;
  final double lysinePct;
  final double methioninePct;
  final double calciumPct;
  final double pricePerKg;
  final double maxInclusionPct;
  final String note;

  const Feedstuff({
    required this.id,
    required this.label,
    required this.category,
    required this.proteinPct,
    required this.energyKcalPerKg,
    required this.lysinePct,
    required this.methioninePct,
    required this.calciumPct,
    required this.pricePerKg,
    required this.maxInclusionPct,
    required this.note,
  });
}

class FeedCatalog {
  static const List<Feedstuff> all = [
    Feedstuff(
      id: 'maize',
      label: 'Maize',
      category: 'Energy',
      proteinPct: 8.5,
      energyKcalPerKg: 3350,
      lysinePct: 0.26,
      methioninePct: 0.18,
      calciumPct: 0.02,
      pricePerKg: 0.28,
      maxInclusionPct: 65,
      note:
          'High-energy cereal base. Cheap source of metabolisable energy but low in protein and lysine, so it is balanced with a protein meal.',
    ),
    Feedstuff(
      id: 'wheat',
      label: 'Wheat',
      category: 'Energy',
      proteinPct: 12.0,
      energyKcalPerKg: 3150,
      lysinePct: 0.35,
      methioninePct: 0.20,
      calciumPct: 0.05,
      pricePerKg: 0.26,
      maxInclusionPct: 55,
      note:
          'Energy cereal with a little more protein than maize. Keep inclusion moderate to avoid sticky droppings from soluble fibre.',
    ),
    Feedstuff(
      id: 'barley',
      label: 'Barley',
      category: 'Energy',
      proteinPct: 11.0,
      energyKcalPerKg: 2750,
      lysinePct: 0.40,
      methioninePct: 0.17,
      calciumPct: 0.06,
      pricePerKg: 0.22,
      maxInclusionPct: 30,
      note:
          'Lower-energy cereal, often a cheaper partial swap for maize. Limit the share because of beta-glucan fibre.',
    ),
    Feedstuff(
      id: 'soybean',
      label: 'Soybean meal',
      category: 'Protein',
      proteinPct: 46.0,
      energyKcalPerKg: 2230,
      lysinePct: 2.85,
      methioninePct: 0.65,
      calciumPct: 0.30,
      pricePerKg: 0.55,
      maxInclusionPct: 35,
      note:
          'Workhorse protein meal with an excellent amino-acid profile and high lysine. Usually the main protein source in layer diets.',
    ),
    Feedstuff(
      id: 'sunflower',
      label: 'Sunflower meal',
      category: 'Protein',
      proteinPct: 32.0,
      energyKcalPerKg: 1850,
      lysinePct: 1.15,
      methioninePct: 0.70,
      calciumPct: 0.35,
      pricePerKg: 0.34,
      maxInclusionPct: 20,
      note:
          'Cheaper protein alternative to soybean. Higher fibre and lower lysine, so it part-replaces soy rather than fully swapping it.',
    ),
    Feedstuff(
      id: 'fishmeal',
      label: 'Fish meal',
      category: 'Protein',
      proteinPct: 62.0,
      energyKcalPerKg: 2800,
      lysinePct: 4.80,
      methioninePct: 1.65,
      calciumPct: 5.00,
      pricePerKg: 1.10,
      maxInclusionPct: 8,
      note:
          'Premium animal protein, very rich in lysine and methionine. Expensive, so used in small amounts to top up amino acids.',
    ),
    Feedstuff(
      id: 'peas',
      label: 'Field peas',
      category: 'Protein',
      proteinPct: 22.0,
      energyKcalPerKg: 2550,
      lysinePct: 1.55,
      methioninePct: 0.22,
      calciumPct: 0.10,
      pricePerKg: 0.40,
      maxInclusionPct: 20,
      note:
          'Home-grown protein-plus-energy legume. Good lysine but short on methionine, so it pairs well with a synthetic top-up.',
    ),
    Feedstuff(
      id: 'limestone',
      label: 'Limestone',
      category: 'Mineral',
      proteinPct: 0.0,
      energyKcalPerKg: 0,
      lysinePct: 0.0,
      methioninePct: 0.0,
      calciumPct: 38.0,
      pricePerKg: 0.08,
      maxInclusionPct: 12,
      note:
          'Calcium carbonate for strong eggshells. Layers need a high calcium intake; coarse limestone helps shell quality.',
    ),
    Feedstuff(
      id: 'dcp',
      label: 'Dicalcium phosphate',
      category: 'Mineral',
      proteinPct: 0.0,
      energyKcalPerKg: 0,
      lysinePct: 0.0,
      methioninePct: 0.0,
      calciumPct: 22.0,
      pricePerKg: 0.65,
      maxInclusionPct: 3,
      note:
          'Supplies available phosphorus and some calcium for bone and shell formation. Used in small, precise amounts.',
    ),
    Feedstuff(
      id: 'oil',
      label: 'Vegetable oil',
      category: 'Energy',
      proteinPct: 0.0,
      energyKcalPerKg: 8800,
      lysinePct: 0.0,
      methioninePct: 0.0,
      calciumPct: 0.0,
      pricePerKg: 1.20,
      maxInclusionPct: 6,
      note:
          'Concentrated energy used to lift the diet density in hot weather or for high-output birds. A little goes a long way.',
    ),
    Feedstuff(
      id: 'dlmet',
      label: 'DL-methionine',
      category: 'Additive',
      proteinPct: 0.0,
      energyKcalPerKg: 0,
      lysinePct: 0.0,
      methioninePct: 99.0,
      calciumPct: 0.0,
      pricePerKg: 3.40,
      maxInclusionPct: 0.5,
      note:
          'Synthetic methionine to hit the first limiting amino acid precisely without overfeeding crude protein.',
    ),
    Feedstuff(
      id: 'llys',
      label: 'L-lysine',
      category: 'Additive',
      proteinPct: 0.0,
      energyKcalPerKg: 0,
      lysinePct: 78.0,
      methioninePct: 0.0,
      calciumPct: 0.0,
      pricePerKg: 2.90,
      maxInclusionPct: 0.5,
      note:
          'Synthetic lysine that lets you trim the protein meal share while keeping the amino-acid balance intact.',
    ),
  ];

  static Feedstuff byId(String id) =>
      all.firstWhere((f) => f.id == id, orElse: () => all.first);

  static List<Feedstuff> energyStuffs() =>
      all.where((f) => f.category == 'Energy').toList();
  static List<Feedstuff> proteinStuffs() =>
      all.where((f) => f.category == 'Protein').toList();
}
