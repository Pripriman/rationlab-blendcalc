import 'package:flutter/material.dart';

import 'domain/ration_repository.dart';
import 'screens/launch_solver_screen.dart';
import 'state/ration_scope.dart';
import 'theme/lab_theme.dart';

class BlendCalcApp extends StatelessWidget {
  final RationRepository ledger;
  const BlendCalcApp({super.key, required this.ledger});

  @override
  Widget build(BuildContext context) {
    return RationScope(
      ledger: ledger,
      child: MaterialApp(
        title: 'Chicken Feed Optimizer',
        debugShowCheckedModeBanner: false,
        theme: LabTheme.build(),
        home: const LaunchSolverScreen(),
      ),
    );
  }
}
