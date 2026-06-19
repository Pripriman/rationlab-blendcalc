import 'package:flutter/material.dart';
import 'lab_palette.dart';
import 'lab_type.dart';

class LabTheme {
  static ThemeData build() {
    final scheme = ColorScheme.fromSeed(
      seedColor: LabPalette.lime,
      primary: LabPalette.limeDeep,
      secondary: LabPalette.teal,
      surface: LabPalette.panel,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: LabPalette.sheet,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: LabPalette.ink,
      ),
      cardTheme: CardThemeData(
        color: LabPalette.panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: LabPalette.rule,
        thickness: 1,
        space: 1,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: LabPalette.limeDeep,
        inactiveTrackColor: LabPalette.sheetDeep,
        thumbColor: LabPalette.panel,
        overlayColor: LabPalette.lime.withValues(alpha: 0.16),
        trackHeight: 5,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 11,
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LabPalette.panel,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        hintStyle: LabType.body(color: LabPalette.slateFaint),
        border: _inputBorder(LabPalette.rule),
        enabledBorder: _inputBorder(LabPalette.rule),
        focusedBorder: _inputBorder(LabPalette.lime),
        errorBorder: _inputBorder(LabPalette.flag),
        focusedErrorBorder: _inputBorder(LabPalette.flag),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: LabPalette.ink,
        contentTextStyle: LabType.bodyStrong(color: Colors.white),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c, width: 1.4),
      );
}
