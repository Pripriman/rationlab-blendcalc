import 'package:flutter/material.dart';

import '../runtime/metric_pulse.dart';
import '../runtime/mix_gate.dart';
import '../theme/lab_palette.dart';
import '../theme/lab_type.dart';
import '../widgets/flask_glyph.dart';
import 'content/mix_lab_surface.dart';
import 'offline_notice_screen.dart';
import 'ration_root.dart';

class LaunchSolverScreen extends StatefulWidget {
  const LaunchSolverScreen({super.key});

  @override
  State<LaunchSolverScreen> createState() => _LaunchSolverScreenState();
}

class _LaunchSolverScreenState extends State<LaunchSolverScreen>
    with SingleTickerProviderStateMixin {
  late Future<GateResult> _future;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _future = MixGate.resolve();
  }

  void _retry() {
    setState(() {
      _future = MixGate.resolve();
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GateResult>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return _splash();
        }
        final result = snap.data ?? const GateResult(GateOutcome.native);
        switch (result.outcome) {
          case GateOutcome.badConnection:
            return OfflineNoticeScreen(onRetry: _retry);
          case GateOutcome.content:
            MetricPulse.contentOpen();
            return MixLabSurface(endpoint: result.endpoint!);
          case GateOutcome.native:
            return const RationRoot();
        }
      },
    );
  }

  Widget _splash() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LabPalette.sheetGradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, child) {
                  return Opacity(
                    opacity: 0.65 + _pulse.value * 0.35,
                    child: child,
                  );
                },
                child: const FlaskGlyph(size: 86),
              ),
              const SizedBox(height: 26),
              Text('Balancing the mix…',
                  style: LabType.heading(color: LabPalette.slate)),
            ],
          ),
        ),
      ),
    );
  }
}
