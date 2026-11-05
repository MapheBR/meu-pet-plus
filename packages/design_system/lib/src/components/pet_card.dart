import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'app_avatar.dart';

/// Card de pet na Home: avatar, nome, resumo (espécie/raça/idade)
/// e [StatusChip] de saúde abaixo do resumo, como no protótipo.
class PetCard extends StatelessWidget {
  const PetCard({
    required this.name,
    required this.subtitle,
    required this.status,
    super.key,
    this.avatarIcon = Icons.pets,
    this.imagePath,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final Widget status;
  final IconData avatarIcon;
  final String? imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          constraints: const BoxConstraints(minHeight: 68),
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: scheme.outline),
          ),
          child: Row(
            children: [
              AppAvatar(icon: avatarIcon, imagePath: imagePath),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(name, style: AppTypography.titleSmall),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    status,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
