import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// Título de seção com ação opcional à direita (ex.: "Meus Pets" + "+").
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: scheme.primary,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
