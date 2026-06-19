import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'domain/ration_repository.dart';
import 'runtime/metric_pulse.dart';
import 'runtime/push_relay.dart';
import 'runtime/ration_link.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  try {
    await RationLink.boot();
  } catch (_) {}

  await PushRelay.boot();
  MetricPulse.boot();

  final ledger = RationRepository();
  await ledger.load();

  await _markFirstOpen();

  runApp(BlendCalcApp(ledger: ledger));
}

Future<void> _markFirstOpen() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    const key = 'mixlab.firstOpenSent';
    if (!(prefs.getBool(key) ?? false)) {
      MetricPulse.firstOpen();
      await prefs.setBool(key, true);
    }
  } catch (_) {}
}
