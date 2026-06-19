import 'package:flutter/material.dart';
import '../theme/lab_palette.dart';
import '../theme/lab_type.dart';

class BarMeter extends StatelessWidget {
  final String label;
  final String valueText;
  final double fraction;
  final Color color;

  const BarMeter({
    super.key,
    required this.label,
    required this.valueText,
    required this.fraction,
    this.color = LabPalette.limeDeep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: LabType.bodyStrong()),
            ),
            Text(valueText,
                style: LabType.figure(13.5, color: LabPalette.ink)),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: fraction.clamp(0, 1),
            minHeight: 8,
            backgroundColor: LabPalette.sheetDeep,
            color: color,
          ),
        ),
      ],
    );
  }
}
