import 'package:flutter/material.dart';

/// Raw color palette of the MeuPet+ design system.
///
/// Identidade definida no TEMA.md: azul-marinho (#102D59) passa
/// confiança/segurança, laranja (#FF9100) traz energia e marca ações,
/// off-white (#F8F7F3) deixa as listas arejadas.
///
/// Widgets nunca leem estas cores direto; elas entram no app pelo
/// [ThemeData] ou por `context.semanticColors`.
class AppColorPalette {
  const AppColorPalette({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.accent,
    required this.onAccent,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.outline,
    required this.ok,
    required this.warning,
    required this.error,
    required this.onError,
  });

  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color accent;
  final Color onAccent;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color outline;
  final Color ok;
  final Color warning;
  final Color error;
  final Color onError;
}

/// The light palette — a única oficial do MeuPet+ por enquanto.
abstract final class AppColors {
  // Identidade MeuPet+ (TEMA.md).
  static const Color navy = Color(0xFF102D59);
  static const Color navyDark = Color(0xFF0B1F3D);
  static const Color navyLight = Color(0xFFDBE5F2);
  static const Color orange = Color(0xFFFF9100);
  static const Color offWhite = Color(0xFFF8F7F3);

  // Status de vacina.
  static const Color okGreen = Color(0xFF1E7A44);
  static const Color okBg = Color(0xFFE8F5EC);
  static const Color warnText = Color(0xFF8A5200);
  static const Color warnBg = Color(0xFFFFF4E0);
  static const Color errRed = Color(0xFFC62828);
  static const Color errBg = Color(0xFFFDECEA);

  static const AppColorPalette light = AppColorPalette(
    primary: navy,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: navyLight,
    onPrimaryContainer: navy,
    accent: orange,
    onAccent: navy, // texto azul sobre botão laranja
    background: offWhite,
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEEF3FA), // azul bem claro (avatar, ícone tile)
    onSurface: Color(0xFF1D2433),
    onSurfaceMuted: Color(0xFF5B6472),
    outline: Color(0xFFE3DFD3),
    ok: okGreen,
    warning: warnText,
    error: errRed,
    onError: Color(0xFFFFFFFF),
  );

  /// Dark palette provisória (o protótipo prevê tema escuro no Perfil).
  static const AppColorPalette dark = AppColorPalette(
    primary: Color(0xFF7FA3DC),
    onPrimary: navyDark,
    primaryContainer: Color(0xFF1B3054),
    onPrimaryContainer: navyLight,
    accent: orange,
    onAccent: navyDark,
    background: navyDark,
    surface: Color(0xFF16304F),
    surfaceVariant: Color(0xFF1E3A5F),
    onSurface: Color(0xFFF8F7F3),
    onSurfaceMuted: Color(0xFFB9C6D8),
    outline: Color(0xFF2A4670),
    ok: Color(0xFF7BC79B),
    warning: Color(0xFFF0B45C),
    error: Color(0xFFE57373),
    onError: navyDark,
  );
}
