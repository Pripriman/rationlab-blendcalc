import 'package:flutter/material.dart';
import '../domain/blend_solver.dart';
import '../domain/nutrient_tint.dart';
import '../theme/lab_type.dart';

class SpecBadge extends StatelessWidget {
  final NutrientState state;
  const SpecBadge({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final color = nutrientTint(state);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(nutrientLabel(state), style: LabType.label(color: color)),
    );
  }
}
