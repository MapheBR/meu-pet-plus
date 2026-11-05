import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Colors that carry meaning in the MeuPet+ app and have no slot in
/// [ColorScheme]: ok (vacina em dia), warning (vence em breve) e error
/// (vencida / falha).
///
/// Registered as a [ThemeExtension] so widgets read them with
/// `context.semanticColors`.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.ok,
    required this.warning,
    required this.error,
    required this.muted,
  });

  factory AppSemanticColors.fromPalette(AppColorPalette palette) {
    return AppSemanticColors(
      ok: palette.ok,
      warning: palette.warning,
      error: palette.error,
      muted: palette.onSurfaceMuted,
    );
  }

  /// Status "em dia" (verde).
  final Color ok;

  /// Status "vence em breve" (laranja → texto escuro sobre fundo claro).
  final Color warning;

  /// Status "vencida" e erros.
  final Color error;

  /// Secondary text color.
  final Color muted;

  @override
  AppSemanticColors copyWith({
    Color? ok,
    Color? warning,
    Color? error,
    Color? muted,
  }) {
    return AppSemanticColors(
      ok: ok ?? this.ok,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      muted: muted ?? this.muted,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      ok: Color.lerp(ok, other.ok, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
    );
  }
}

/// Shortcut: `context.semanticColors.ok`.
extension SemanticColorsContext on BuildContext {
  AppSemanticColors get semanticColors {
    final colors = Theme.of(this).extension<AppSemanticColors>();
    assert(
      colors != null,
      'AppSemanticColors is missing. Use AppTheme.light() or AppTheme.dark().',
    );
    return colors!;
  }
}
