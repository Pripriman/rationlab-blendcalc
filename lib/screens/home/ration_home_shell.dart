import 'package:flutter/material.dart';

import '../../runtime/push_relay.dart';
import '../../runtime/ration_link.dart';
import '../../theme/lab_palette.dart';
import '../../theme/lab_type.dart';
import '../access/account_gate.dart';
import 'cost_per_egg_view.dart';
import 'feed_swap_view.dart';
import 'mix_solver_view.dart';
import 'ration_calculator_view.dart';
import 'supplier_quotes_view.dart';

class RationHomeShell extends StatefulWidget {
  const RationHomeShell({super.key});

  @override
  State<RationHomeShell> createState() => _RationHomeShellState();
}

class _RationHomeShellState extends State<RationHomeShell> {
  int _tab = 0;

  static const _titles = [
    'Ration calculator',
    'Cheaper swaps',
    'Cost per egg',
    'Mix solver',
    'Supplier prices',
  ];

  void _openAccount() {
    final signedIn = RationLink.signedIn;
    showModalBottomSheet(
      context: context,
      backgroundColor: LabPalette.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account', style: LabType.heading()),
                const SizedBox(height: 6),
                Text(
                  signedIn
                      ? (RationLink.currentUser?.email ?? 'Signed in')
                      : 'You are working as a guest.',
                  style: LabType.body(),
                ),
                const SizedBox(height: 16),
                if (signedIn)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout_rounded,
                        color: LabPalette.flag),
                    title: Text('Sign out',
                        style: LabType.bodyStrong(color: LabPalette.flag)),
                    onTap: () async {
                      await PushRelay.unbindUser();
                      await RationLink.signOut();
                      if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                      if (mounted) setState(() {});
                    },
                  )
                else
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.login_rounded,
                        color: LabPalette.limeDeep),
                    title: Text('Sign in or create account',
                        style:
                            LabType.bodyStrong(color: LabPalette.limeDeep)),
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AccountGate(
                            onDone: () {
                              Navigator.of(context).maybePop();
                              if (mounted) setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    switch (_tab) {
      case 0:
        body = const RationCalculatorView();
        break;
      case 1:
        body = const FeedSwapView();
        break;
      case 2:
        body = const CostPerEggView();
        break;
      case 3:
        body = const MixSolverView();
        break;
      case 4:
        body = const SupplierQuotesView();
        break;
      default:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: LabPalette.sheet,
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(_titles[_tab], style: LabType.title()),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            color: LabPalette.ink,
            onPressed: _openAccount,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: body,
      bottomNavigationBar: _BottomBar(
        index: _tab,
        onChanged: (i) => setState(() => _tab = i),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _BottomBar({required this.index, required this.onChanged});

  static const _items = [
    (Icons.tune_rounded, 'Ration'),
    (Icons.swap_horiz_rounded, 'Swaps'),
    (Icons.egg_outlined, 'Cost'),
    (Icons.auto_awesome_rounded, 'Solver'),
    (Icons.storefront_outlined, 'Prices'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: LabPalette.panel,
        border: Border(top: BorderSide(color: LabPalette.rule)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (i) {
              final selected = i == index;
              final item = _items[i];
              return Expanded(
                child: InkResponse(
                  onTap: () => onChanged(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.$1,
                        size: 22,
                        color: selected
                            ? LabPalette.limeDeep
                            : LabPalette.slateFaint,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.$2,
                        style: LabType.caption(
                          color: selected
                              ? LabPalette.limeDeep
                              : LabPalette.slateFaint,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
