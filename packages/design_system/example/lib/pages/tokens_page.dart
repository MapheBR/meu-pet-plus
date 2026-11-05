import 'package:flutter/material.dart';
import 'package:meupet_design_system/meupet_design_system.dart';

import '../main.dart';

/// Mostra os tokens virando valores reais: cores, espaçamento,
/// radius, tipografia e durações.
class TokensPage extends StatelessWidget {
  const TokensPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppScaffold(
      title: 'Tokens',
      actions: const [ThemeModeButton()],
      body: ListView(
        children: [
          const SectionHeader(title: 'Cores'),
          _ColorRow('colorPrimary', AppColors.navy, scheme.primary),
          _ColorRow('colorAccent', AppColors.orange, scheme.secondary),
          _ColorRow('colorBackground', AppColors.offWhite, scheme.surface),
          _ColorRow('colorSurface', Colors.white, scheme.surface),
          const Gap.sm(),
          const SectionHeader(title: 'Status'),
          _ColorRow('statusOk', AppColors.okGreen, context.semanticColors.ok),
          _ColorRow(
            'statusWarning',
            AppColors.warnText,
            context.semanticColors.warning,
          ),
          _ColorRow('statusError', AppColors.errRed, context.semanticColors.error),
          const Gap.sm(),
          const SectionHeader(title: 'Tipografia'),
          Text('Display — Poppins 700', style: AppTypography.displayLarge),
          const Gap.xs(),
          Text('Title large — Poppins 700', style: AppTypography.titleLarge),
          Text('Title medium — Poppins 600', style: AppTypography.titleMedium),
          Text('Title small — Poppins 600', style: AppTypography.titleSmall),
          const Gap.xs(),
          Text('Body large — Inter 400', style: AppTypography.bodyLarge),
          Text('Body small — Inter 12', style: AppTypography.bodySmall),
          Text('Label small — Inter 12/600', style: AppTypography.labelSmall),
          const Gap.sm(),
          const SectionHeader(title: 'Espaçamento (múltiplos de 4)'),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final s in [
                AppSpacing.xxs,
                AppSpacing.xs,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xl,
              ])
                _SpaceBox(size: s),
            ],
          ),
          const Gap.sm(),
          const SectionHeader(title: 'Radius'),
          Row(
            children: [
              _RadiusBox(AppRadius.sm, 'sm 10'),
              const Gap.sm(),
              _RadiusBox(AppRadius.md, 'md 12'),
              const Gap.sm(),
              _RadiusBox(AppRadius.lg, 'lg 16'),
              const Gap.sm(),
              _RadiusBox(AppRadius.pill, 'pill'),
            ],
          ),
          const Gap.sm(),
          const SectionHeader(title: 'Durações'),
          Text(
            'fast ${AppDurations.fast.inMilliseconds}ms · '
            'normal ${AppDurations.normal.inMilliseconds}ms · '
            'slow ${AppDurations.slow.inMilliseconds}ms',
            style: AppTypography.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow(this.name, this.value, this.usedInTheme);

  final String name;
  final Color value;
  final Color usedInTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: value,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.labelSmall),
                Text(
                  '#${value.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, size: 16, color: usedInTheme),
        ],
      ),
    );
  }
}

class _SpaceBox extends StatelessWidget {
  const _SpaceBox({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(width: size, height: size, color: AppColors.orange),
        const SizedBox(height: 2),
        Text('$size', style: AppTypography.bodySmall),
      ],
    );
  }
}

class _RadiusBox extends StatelessWidget {
  const _RadiusBox(this.radius, this.label);

  final double radius;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.navyLight,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}
