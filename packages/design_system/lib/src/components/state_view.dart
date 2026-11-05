import 'package:flutter/material.dart';

import '../theme/app_semantic_colors.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import 'app_button.dart';

enum _StateKind { loading, empty, error }

/// Full-area placeholder for the three non-content states of a screen:
/// skeleton de carregamento, vazio e erro (regra do protótipo).
///
/// ```dart
/// StateView.loading()
/// StateView.empty(
///   message: 'Nenhum pet cadastrado',
///   actionLabel: 'Cadastrar pet',
///   onAction: () {},
/// )
/// StateView.error(message: 'Sem conexão', onRetry: vm.load.execute)
/// ```
class StateView extends StatelessWidget {
  const StateView.loading({super.key, this.message})
    : _kind = _StateKind.loading,
      icon = null,
      actionLabel = null,
      onAction = null;

  const StateView.empty({
    required String this.message,
    super.key,
    this.icon = Icons.pets_outlined,
    this.actionLabel,
    this.onAction,
  }) : _kind = _StateKind.empty;

  const StateView.error({
    required String this.message,
    super.key,
    VoidCallback? onRetry,
    this.icon = Icons.error_outline,
    this.actionLabel = 'Tentar novamente',
  }) : _kind = _StateKind.error,
       onAction = onRetry;

  final _StateKind _kind;
  final String? message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semanticColors;
    final scheme = theme.colorScheme;

    final Widget visual = switch (_kind) {
      _StateKind.loading => _SkeletonList(),
      _StateKind.empty => _StateIcon(
        icon: icon!,
        color: scheme.primary,
        background: scheme.primaryContainer,
      ),
      _StateKind.error => _StateIcon(
        icon: icon!,
        color: semantic.error,
        background: AppColors.errBg,
      ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            visual,
            if (message != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: semantic.muted,
                ),
              ),
            ],
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton.secondary(
                label: actionLabel!,
                onPressed: onAction,
                expanded: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StateIcon extends StatelessWidget {
  const _StateIcon({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, size: 40, color: color),
    );
  }
}

/// Skeleton no formato de um card de pet (avatar + linhas + chip).
class _SkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++) ...[
          _SkeletonCard(),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          _Bar(width: 44, height: 44, round: true),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bar(width: 80, height: 13),
                const SizedBox(height: AppSpacing.xs),
                _Bar(width: 140, height: 11),
              ],
            ),
          ),
          _Bar(width: 72, height: 24, round: true),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.height, this.round = false});

  final double width;
  final double height;
  final bool round;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E4D8),
        borderRadius: BorderRadius.circular(round ? 999 : 8),
      ),
    );
  }
}
