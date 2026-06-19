import 'blend_solver.dart';

class SavedRation {
  final String id;
  DateTime createdAt;
  String name;
  String flockProfileId;
  List<BlendPart> parts;
  double costPerKg;
  double proteinPct;
  String note;

  SavedRation({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.flockProfileId,
    required this.parts,
    required this.costPerKg,
    required this.proteinPct,
    this.note = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'name': name,
        'profile': flockProfileId,
        'parts': parts
            .map((p) => {'feed': p.feedId, 'share': p.sharePct})
            .toList(),
        'costPerKg': costPerKg,
        'proteinPct': proteinPct,
        'note': note,
      };

  static SavedRation fromJson(Map<String, dynamic> j) => SavedRation(
        id: j['id'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        name: j['name'] as String? ?? 'Ration',
        flockProfileId: j['profile'] as String? ?? '',
        parts: ((j['parts'] as List?) ?? const [])
            .map((e) => BlendPart(
                  (e as Map<String, dynamic>)['feed'] as String,
                  (e['share'] as num).toDouble(),
                ))
            .toList(),
        costPerKg: (j['costPerKg'] as num?)?.toDouble() ?? 0,
        proteinPct: (j['proteinPct'] as num?)?.toDouble() ?? 0,
        note: j['note'] as String? ?? '',
      );
}
