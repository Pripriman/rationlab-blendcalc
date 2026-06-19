import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blendcalc/domain/blend_solver.dart';
import 'package:blendcalc/domain/feed_catalog.dart';
import 'package:blendcalc/domain/flock_profiles.dart';
import 'package:blendcalc/widgets/flask_glyph.dart';

void main() {
  testWidgets('FlaskGlyph renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: FlaskGlyph(size: 80)),
        ),
      ),
    );
    expect(find.byType(FlaskGlyph), findsOneWidget);
  });

  test('feed catalog covers core feedstuffs', () {
    expect(FeedCatalog.byId('soybean').category, 'Protein');
    expect(FeedCatalog.byId('maize').category, 'Energy');
    expect(FeedCatalog.byId('limestone').calciumPct, greaterThan(30));
  });

  test('blend profile is a weighted average of parts', () {
    final parts = [
      const BlendPart('maize', 70),
      const BlendPart('soybean', 25),
      const BlendPart('limestone', 5),
    ];
    final blend = BlendSolver.profileOf(parts);
    expect(blend.proteinPct, greaterThan(0));
    expect(blend.costPerKg, greaterThan(0));
    expect(BlendSolver.totalShare(parts), 100);
  });

  test('least-cost solver returns an on-spec mix for a layer', () {
    final layer = FlockProfiles.byId('layer_peak');
    final parts = BlendSolver.solveLeastCost(layer);
    expect(parts, isNotEmpty);
    final blend = BlendSolver.profileOf(parts);
    expect(BlendSolver.meetsSpec(blend, layer.target), isTrue);
  });
}
