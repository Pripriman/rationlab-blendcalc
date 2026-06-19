import 'package:flutter/material.dart';
import '../theme/lab_palette.dart';
import '../theme/lab_type.dart';

class StepperField extends StatelessWidget {
  final String label;
  final double value;
  final double step;
  final double min;
  final double max;
  final String unit;
  final ValueChanged<double> onChanged;

  const StepperField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.min = 0,
    this.max = 100,
    this.unit = '',
  });

  void _bump(double delta) {
    final next = (value + delta).clamp(min, max);
    onChanged(double.parse(next.toStringAsFixed(2)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: LabType.bodyStrong()),
        ),
        _btn(Icons.remove_rounded, () => _bump(-step)),
        Container(
          width: 78,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Text(
            unit.isEmpty
                ? value.toStringAsFixed(value % 1 == 0 ? 0 : 1)
                : '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)} $unit',
            style: LabType.figure(15),
          ),
        ),
        _btn(Icons.add_rounded, () => _bump(step)),
      ],
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return Material(
      color: LabPalette.sheetDeep,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 19, color: LabPalette.ink),
        ),
      ),
    );
  }
}
