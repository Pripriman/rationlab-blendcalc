import 'package:flutter/material.dart';
import 'lab_palette.dart';

class LabType {
  static TextStyle _t(
    FontWeight weight,
    double size, {
    double? height,
    double? spacing,
    Color? color,
  }) {
    return TextStyle(
      fontWeight: weight,
      fontSize: size,
      height: height,
      letterSpacing: spacing,
      color: color ?? LabPalette.ink,
    );
  }

  static TextStyle display({Color? color}) =>
      _t(FontWeight.w800, 28, height: 1.1, spacing: -0.4, color: color);
  static TextStyle title({Color? color}) =>
      _t(FontWeight.w700, 21, height: 1.16, spacing: -0.2, color: color);
  static TextStyle heading({Color? color}) =>
      _t(FontWeight.w700, 16.5, height: 1.2, color: color);
  static TextStyle body({Color? color}) =>
      _t(FontWeight.w400, 14.5, height: 1.45, color: color ?? LabPalette.slate);
  static TextStyle bodyStrong({Color? color}) =>
      _t(FontWeight.w600, 14.5, height: 1.42, color: color);
  static TextStyle label({Color? color}) =>
      _t(FontWeight.w700, 12, spacing: 0.9, color: color ?? LabPalette.slate);
  static TextStyle caption({Color? color}) =>
      _t(FontWeight.w600, 11.5, spacing: 0.3, color: color ?? LabPalette.slateFaint);

  static TextStyle figure(double size, {Color? color, FontWeight? weight}) =>
      TextStyle(
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: weight ?? FontWeight.w700,
        fontSize: size,
        height: 1.0,
        letterSpacing: 0.2,
        color: color ?? LabPalette.ink,
      );

  static TextStyle readout(double size, {Color? color, double spacing = 0.5}) =>
      TextStyle(
        fontFamily: 'monospace',
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w700,
        fontSize: size,
        height: 1.0,
        letterSpacing: spacing,
        color: color ?? LabPalette.ink,
      );
}
