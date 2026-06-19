import 'package:flutter/material.dart';
import '../theme/lab_palette.dart';

class FlaskGlyph extends StatelessWidget {
  final double size;
  final Color color;
  final Color fill;

  const FlaskGlyph({
    super.key,
    this.size = 48,
    this.color = LabPalette.limeDeep,
    this.fill = LabPalette.lime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FlaskPainter(color, fill)),
    );
  }
}

class _FlaskPainter extends CustomPainter {
  final Color color;
  final Color fill;
  _FlaskPainter(this.color, this.fill);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeJoin = StrokeJoin.round;

    final body = Path();
    body.moveTo(w * 0.40, h * 0.12);
    body.lineTo(w * 0.40, h * 0.42);
    body.lineTo(w * 0.18, h * 0.80);
    body.cubicTo(w * 0.13, h * 0.90, w * 0.20, h * 0.94, w * 0.30, h * 0.94);
    body.lineTo(w * 0.70, h * 0.94);
    body.cubicTo(w * 0.80, h * 0.94, w * 0.87, h * 0.90, w * 0.82, h * 0.80);
    body.lineTo(w * 0.60, h * 0.42);
    body.lineTo(w * 0.60, h * 0.12);

    final liquid = Path();
    liquid.moveTo(w * 0.285, h * 0.66);
    liquid.lineTo(w * 0.715, h * 0.66);
    liquid.lineTo(w * 0.70, h * 0.80);
    liquid.cubicTo(w * 0.73, h * 0.88, w * 0.66, h * 0.90, w * 0.58, h * 0.90);
    liquid.lineTo(w * 0.42, h * 0.90);
    liquid.cubicTo(w * 0.34, h * 0.90, w * 0.27, h * 0.88, w * 0.30, h * 0.80);
    liquid.close();

    final fillPaint = Paint()
      ..color = fill.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    canvas.drawPath(liquid, fillPaint);
    canvas.drawPath(body, stroke);

    canvas.drawLine(
      Offset(w * 0.32, h * 0.12),
      Offset(w * 0.68, h * 0.12),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _FlaskPainter old) =>
      old.color != color || old.fill != fill;
}
