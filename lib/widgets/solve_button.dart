import 'package:flutter/material.dart';
import '../theme/lab_palette.dart';
import '../theme/lab_type.dart';

class SolveButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final bool expand;
  final IconData? icon;

  const SolveButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.expand = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !busy;
    final btn = Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: enabled ? onPressed : null,
          child: Ink(
            decoration: BoxDecoration(
              color: LabPalette.limeDeep,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 52,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: busy
                  ? const SizedBox(
                      width: 21,
                      height: 21,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 19),
                          const SizedBox(width: 9),
                        ],
                        Text(label,
                            style: LabType.heading(color: Colors.white)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

class TextLink extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const TextLink({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: LabPalette.limeDeep,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 17),
            const SizedBox(width: 7),
          ],
          Text(label, style: LabType.label(color: LabPalette.limeDeep)),
        ],
      ),
    );
  }
}
