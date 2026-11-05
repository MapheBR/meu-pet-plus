import 'package:flutter/material.dart';
import 'package:meupet_design_system/meupet_design_system.dart';

import '../main.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  // Dados do protótipo: Thor, 15/06 → 02/11/2026.
  static final _points = [
    WeightPoint(date: DateTime(2026, 6, 15), kg: 27.9),
    WeightPoint(date: DateTime(2026, 9, 12), kg: 28.1),
    WeightPoint(date: DateTime(2026, 11, 2), kg: 28.4),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppScaffold(
      title: 'Gráfico de peso',
      actions: const [ThemeModeButton()],
      body: ListView(
        children: [
          const SectionHeader(title: 'Peso atual'),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: scheme.outline),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('28,4 kg', style: AppTypography.headlineMedium),
                      Text(
                        'último registro · 02/11/2026',
                        style: AppTypography.bodySmall.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusChip.ok(
                  label: '+0,5 kg em 5 meses',
                  icon: Icons.trending_up,
                ),
              ],
            ),
          ),
          const Gap.sm(),
          const SectionHeader(title: 'WeightChart'),
          WeightChart(points: _points),
          const Gap.sm(),
          const SectionHeader(title: 'Histórico'),
          InfoCard(
            icon: Icons.monitor_weight_outlined,
            title: 'Histórico',
            subtitle: '02/11 — 28,4 kg · 12/09 — 28,1 kg · 15/06 — 27,9 kg',
          ),
        ],
      ),
    );
  }
}
