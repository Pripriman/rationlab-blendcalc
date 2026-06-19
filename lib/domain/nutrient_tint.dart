import 'package:flutter/material.dart';
import 'blend_solver.dart';
import '../theme/lab_palette.dart';

Color nutrientTint(NutrientState state) {
  switch (state) {
    case NutrientState.underrun:
      return LabPalette.underrun;
    case NutrientState.withinSpec:
      return LabPalette.withinSpec;
    case NutrientState.overrun:
      return LabPalette.overrun;
  }
}

String nutrientLabel(NutrientState state) {
  switch (state) {
    case NutrientState.underrun:
      return 'Under';
    case NutrientState.withinSpec:
      return 'On spec';
    case NutrientState.overrun:
      return 'Over';
  }
}
