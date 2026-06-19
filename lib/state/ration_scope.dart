import 'package:flutter/widgets.dart';
import '../domain/ration_repository.dart';

class RationScope extends InheritedNotifier<RationRepository> {
  const RationScope({
    super.key,
    required RationRepository ledger,
    required super.child,
  }) : super(notifier: ledger);

  static RationRepository of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<RationScope>();
    assert(scope != null, 'RationScope not found in context');
    return scope!.notifier!;
  }

  static RationRepository read(BuildContext context) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<RationScope>()
        ?.widget as RationScope?;
    return scope!.notifier!;
  }
}
