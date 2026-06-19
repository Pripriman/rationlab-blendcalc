import 'package:flutter/material.dart';
import '../theme/lab_palette.dart';
import '../theme/lab_type.dart';
import '../widgets/solve_button.dart';

class OfflineNoticeScreen extends StatelessWidget {
  final VoidCallback onRetry;
  const OfflineNoticeScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LabPalette.sheetGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: LabPalette.amberWash,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.cloud_off_rounded,
                      size: 36, color: LabPalette.amber),
                ),
                const SizedBox(height: 22),
                Text('No connection to the lab',
                    style: LabType.title(), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(
                  'We could not sync the latest configuration. Check your network and recalculate.',
                  style: LabType.body(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 26),
                SolveButton(
                  label: 'Recalculate',
                  icon: Icons.refresh_rounded,
                  expand: false,
                  onPressed: onRetry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
