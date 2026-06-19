import 'package:flutter/material.dart';

class LabPalette {
  static const Color sheet = Color(0xFFF7F9FA);
  static const Color sheetDeep = Color(0xFFEDF1F3);
  static const Color rule = Color(0xFFDDE3E7);
  static const Color panel = Color(0xFFFFFFFF);

  static const Color ink = Color(0xFF1B2127);
  static const Color slate = Color(0xFF5B6770);
  static const Color slateFaint = Color(0xFF9AA6AE);

  static const Color lime = Color(0xFF6FBF2C);
  static const Color limeDeep = Color(0xFF4E9A18);
  static const Color limeWash = Color(0xFFEAF6DD);

  static const Color teal = Color(0xFF2BA8A0);
  static const Color amber = Color(0xFFE0A52A);
  static const Color amberWash = Color(0xFFFAF0D6);
  static const Color flag = Color(0xFFD5524A);
  static const Color flagWash = Color(0xFFF8E0DE);

  static const Color underrun = Color(0xFFD5524A);
  static const Color withinSpec = Color(0xFF4E9A18);
  static const Color overrun = Color(0xFFE0A52A);

  static const LinearGradient sheetGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEFF4F2), Color(0xFFFAFCFB)],
  );
}
