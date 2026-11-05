import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';

/// Status visual de um registro — regra do protótipo:
/// **em dia** (verde), **vence em breve** (laranja) e **vencida** (vermelho).
///
/// O app calcula o estado a partir das datas; o chip só desenha.
enum AppStatus { ok, warning, error, neutral }

class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    required this.status,
    super.key,
    this.icon,
  });

  /// Atalho: `StatusChip.ok(label: 'Em dia')`.
  // ignore: use_key_in_widget_constructors
  const StatusChip.ok({required String label, IconData? icon})
    : this(label: label, status: AppStatus.ok, icon: icon);

  // ignore: use_key_in_widget_constructors
  const StatusChip.warning({required String label, IconData? icon})
    : this(label: label, status: AppStatus.warning, icon: icon);

  // ignore: use_key_in_widget_constructors
  const StatusChip.error({required String label, IconData? icon})
    : this(label: label, status: AppStatus.error, icon: icon);

  final String label;
  final AppStatus status;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final semantic = context.semanticColors;
    final scheme = Theme.of(context).colorScheme;

    // Regra do protótipo: texto laranja só sobre fundo azul-marinho.
    // Sobre fundo claro, o laranja aparece só no ícone/borda.
    final (fg, bg, iconColor) = switch (status) {
      AppStatus.ok => (semantic.ok, AppColors.okBg, semantic.ok),
      AppStatus.warning => (
        AppColors.warnText,
        AppColors.warnBg,
        AppColors.orange,
      ),
      AppStatus.error => (semantic.error, AppColors.errBg, semantic.error),
      AppStatus.neutral => (
        scheme.onSurface,
        scheme.surface,
        semantic.muted,
      ),
    };

    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm - 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
