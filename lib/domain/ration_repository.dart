import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'blend_solver.dart';
import 'ration_models.dart';

class RationRepository extends ChangeNotifier {
  static const _storeKey = 'mixlab.rations';
  static const _uuid = Uuid();

  final List<SavedRation> _rations = [];
  bool _loaded = false;

  List<SavedRation> get rations => List.unmodifiable(_rations);
  bool get isLoaded => _loaded;
  int get totalRations => _rations.length;

  double get cheapestCostPerKg {
    if (_rations.isEmpty) return 0;
    return _rations
        .map((r) => r.costPerKg)
        .reduce((a, b) => a < b ? a : b);
  }

  double get averageCostPerKg {
    if (_rations.isEmpty) return 0;
    final sum = _rations.fold<double>(0, (a, r) => a + r.costPerKg);
    return sum / _rations.length;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storeKey);
    _rations.clear();
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List;
        for (final e in list) {
          _rations.add(SavedRation.fromJson(e as Map<String, dynamic>));
        }
      } catch (_) {}
    }
    _rations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_rations.map((e) => e.toJson()).toList());
    await prefs.setString(_storeKey, encoded);
  }

  Future<SavedRation> add({
    required String name,
    required String flockProfileId,
    required List<BlendPart> parts,
    required double costPerKg,
    required double proteinPct,
    String note = '',
  }) async {
    final ration = SavedRation(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      name: name,
      flockProfileId: flockProfileId,
      parts: parts,
      costPerKg: costPerKg,
      proteinPct: proteinPct,
      note: note,
    );
    _rations.insert(0, ration);
    await _persist();
    notifyListeners();
    return ration;
  }

  Future<void> remove(String id) async {
    _rations.removeWhere((r) => r.id == id);
    await _persist();
    notifyListeners();
  }
}
