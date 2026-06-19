import 'dart:math' as math;

import 'feed_catalog.dart';

class SupplierQuote {
  final String supplier;
  final String region;
  final String feedId;
  final double pricePerKg;
  final bool inStock;
  final int leadDays;

  const SupplierQuote({
    required this.supplier,
    required this.region,
    required this.feedId,
    required this.pricePerKg,
    required this.inStock,
    required this.leadDays,
  });
}

class SupplierBook {
  static const _suppliers = [
    ('GreenField Mills', 'Central'),
    ('Harvest Co-op', 'North'),
    ('AgriBulk Trading', 'Port'),
    ('Valley Feeds', 'South'),
    ('Prairie Grain Hub', 'West'),
  ];

  static List<SupplierQuote> quotesFor(String feedId) {
    final base = FeedCatalog.byId(feedId).pricePerKg;
    final r = math.Random(feedId.hashCode);
    return List.generate(_suppliers.length, (i) {
      final s = _suppliers[i];
      final swing = (r.nextDouble() - 0.45) * 0.22;
      final price = (base * (1 + swing)).clamp(0.05, 99.0);
      return SupplierQuote(
        supplier: s.$1,
        region: s.$2,
        feedId: feedId,
        pricePerKg: double.parse(price.toStringAsFixed(3)),
        inStock: r.nextInt(10) > 1,
        leadDays: 1 + r.nextInt(8),
      );
    })
      ..sort((a, b) => a.pricePerKg.compareTo(b.pricePerKg));
  }

  static double bestPrice(String feedId) {
    final q = quotesFor(feedId).where((e) => e.inStock).toList();
    if (q.isEmpty) return FeedCatalog.byId(feedId).pricePerKg;
    return q.first.pricePerKg;
  }
}
