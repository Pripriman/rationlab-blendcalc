import 'package:flutter/material.dart';

import '../../domain/feed_catalog.dart';
import '../../domain/supplier_book.dart';
import '../../theme/lab_palette.dart';
import '../../theme/lab_type.dart';
import '../../widgets/lab_card.dart';

class SupplierQuotesView extends StatefulWidget {
  const SupplierQuotesView({super.key});

  @override
  State<SupplierQuotesView> createState() => _SupplierQuotesViewState();
}

class _SupplierQuotesViewState extends State<SupplierQuotesView> {
  Feedstuff _feed = FeedCatalog.byId('maize');

  @override
  Widget build(BuildContext context) {
    final quotes = SupplierBook.quotesFor(_feed.id);
    final best = quotes.where((q) => q.inStock).toList();
    final bestPrice = best.isEmpty ? null : best.first.pricePerKg;

    return Column(
      children: [
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: FeedCatalog.all.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final f = FeedCatalog.all[i];
              final sel = f.id == _feed.id;
              return GestureDetector(
                onTap: () => setState(() => _feed = f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: sel ? LabPalette.limeDeep : LabPalette.panel,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sel ? LabPalette.limeDeep : LabPalette.rule,
                    ),
                  ),
                  child: Text(f.label,
                      style: LabType.label(
                          color: sel ? Colors.white : LabPalette.slate)),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              LabCard(
                color: LabPalette.limeWash,
                border: Border.all(color: LabPalette.lime),
                child: Row(
                  children: [
                    const Icon(Icons.local_offer_outlined,
                        color: LabPalette.limeDeep),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Best in-stock price for ${_feed.label}',
                              style: LabType.bodyStrong(color: LabPalette.ink)),
                          const SizedBox(height: 2),
                          Text(
                            bestPrice == null
                                ? 'No supplier currently in stock'
                                : 'from ${best.first.supplier} · ${best.first.region}',
                            style: LabType.caption(),
                          ),
                        ],
                      ),
                    ),
                    if (bestPrice != null)
                      Text('\$${bestPrice.toStringAsFixed(3)}',
                          style:
                              LabType.readout(18, color: LabPalette.limeDeep)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Supplier quotes', style: LabType.label()),
              const SizedBox(height: 10),
              ...quotes.map(_quoteCard),
              const SizedBox(height: 12),
              Text(
                'Prices are indicative reference quotes for planning and are not live purchase offers.',
                style: LabType.caption(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quoteCard(SupplierQuote q) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: LabCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: LabPalette.sheetDeep,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(Icons.store_mall_directory_outlined,
                  size: 21, color: LabPalette.slate),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.supplier, style: LabType.bodyStrong()),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(q.region, style: LabType.caption()),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: q.inStock
                              ? LabPalette.limeWash
                              : LabPalette.flagWash,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          q.inStock
                              ? 'In stock · ${q.leadDays}d'
                              : 'Out of stock',
                          style: LabType.caption(
                              color: q.inStock
                                  ? LabPalette.limeDeep
                                  : LabPalette.flag),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text('\$${q.pricePerKg.toStringAsFixed(3)}',
                style: LabType.readout(15, color: LabPalette.ink)),
          ],
        ),
      ),
    );
  }
}
