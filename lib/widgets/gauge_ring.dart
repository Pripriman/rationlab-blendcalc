import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/lab_palette.dart';

class GaugeRing extends StatelessWidget {
  final double size;
  final double progress;
  final Color color;
  final Color track;
  final double stroke;
  final Widget? child;

  const GaugeRing({
    super.key,
    required this.size,
    required this.progress,
    this.color = LabPalette.limeDeep,
    this.track = LabPalette.sheetDeep,
    this.stroke = 11,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress.clamp(0, 1).toDouble(),
          color: color,
          track: track,
          stroke: stroke,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color track;
  final double stroke;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.track,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final sweep = 2 * math.pi * progress;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.track != track ||
      old.stroke != stroke;
}
