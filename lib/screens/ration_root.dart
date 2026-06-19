import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'access/account_gate.dart';
import 'home/ration_home_shell.dart';
import 'intro/intro_reel.dart';

enum _Stage { boot, intro, access, home }

class RationRoot extends StatefulWidget {
  const RationRoot({super.key});

  @override
  State<RationRoot> createState() => _RationRootState();
}

class _RationRootState extends State<RationRoot> {
  static const _introKey = 'mixlab.introSeen';
  _Stage _stage = _Stage.boot;

  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final prefs = await SharedPreferences.getInstance();
    final introSeen = prefs.getBool(_introKey) ?? false;
    if (!mounted) return;
    setState(() => _stage = introSeen ? _Stage.home : _Stage.intro);
  }

  Future<void> _finishIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_introKey, true);
    if (!mounted) return;
    setState(() => _stage = _Stage.access);
  }

  void _finishAccess() => setState(() => _stage = _Stage.home);

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case _Stage.boot:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case _Stage.intro:
        return IntroReel(onDone: _finishIntro);
      case _Stage.access:
        return AccountGate(onDone: _finishAccess);
      case _Stage.home:
        return const RationHomeShell();
    }
  }
}
