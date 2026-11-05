import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// Campo de formulário do design system: rótulo acima do campo
/// (regra do protótipo — placeholder some ao digitar, rótulo não).
///
/// Altura mínima de 44px, cantos de 10, ícone opcional à esquerda.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    super.key,
    this.controller,
    this.hint,
    this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelSmall),
        const SizedBox(height: AppSpacing.xs - AppSpacing.xxs),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon == null
                ? null
                : Icon(icon, size: 20, color: theme.hintColor),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: AppRadius.smAll,
              borderSide: const BorderSide(color: Color(0xFFD8D4C8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.smAll,
              borderSide: const BorderSide(color: Color(0xFFD8D4C8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.smAll,
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
      ],
    );
  }
}

/// Opções de seleção em chips (ex.: espécie Cachorro/Gato do form de pet).
/// Altura mínima de toque 44px.
class AppChoiceChips extends StatelessWidget {
  const AppChoiceChips({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SizedBox(
      height: AppSpacing.minTouchTarget + AppSpacing.xs,
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: GestureDetector(
                onTap: () => onSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: i == selectedIndex
                        ? scheme.primaryContainer
                        : scheme.surface,
                    borderRadius: AppRadius.smAll,
                    border: Border.all(
                      color: i == selectedIndex
                          ? scheme.primary
                          : const Color(0xFFD8D4C8),
                      width: i == selectedIndex ? 1.5 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    options[i],
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: i == selectedIndex
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: i == selectedIndex
                          ? scheme.primary
                          : theme.hintColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
