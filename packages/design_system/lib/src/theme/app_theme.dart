import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'app_semantic_colors.dart';

/// Builds the [ThemeData] of the app from the tokens.
///
/// Identidade MeuPet+: primary = azul-marinho, accent = laranja.
/// Botões com cantos de 12, campos preenchidos com borda sutil,
/// bottom nav só com Início e Perfil.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColorPalette p, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: p.primary,
      onPrimary: p.onPrimary,
      primaryContainer: p.primaryContainer,
      onPrimaryContainer: p.onPrimaryContainer,
      secondary: p.accent,
      onSecondary: p.onAccent,
      surface: p.surface,
      onSurface: p.onSurface,
      surfaceContainerHighest: p.surfaceVariant,
      onSurfaceVariant: p.onSurfaceMuted,
      outline: p.outline,
      outlineVariant: p.outline,
      error: p.error,
      onError: p.onError,
    );

    final textTheme = AppTypography.textTheme.apply(
      bodyColor: p.onSurface,
      displayColor: p.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      canvasColor: p.background,
      textTheme: textTheme,
      dividerColor: p.outline,
      splashFactory: InkSparkle.splashFactory,
      extensions: [AppSemanticColors.fromPalette(p)],

      // App bar com marca: fundo azul-marinho, texto claro.
      appBarTheme: AppBarTheme(
        backgroundColor: p.primary,
        foregroundColor: p.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.titleMedium.copyWith(
          color: p.onPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
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
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.smAll,
          borderSide: BorderSide(color: p.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.smAll,
          borderSide: BorderSide(color: p.error, width: 2),
        ),
        labelStyle: AppTypography.bodySmall.copyWith(
          color: p.onSurfaceMuted,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: const Color(0xFF8A93A3),
        ),
      ),

      // Primário: azul-marinho com texto branco.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(46),
          backgroundColor: p.primary,
          foregroundColor: p.onPrimary,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      // Accent: laranja com texto azul-marinho (regra do protótipo).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(46),
          backgroundColor: p.accent,
          foregroundColor: p.onAccent,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      // Secundário/contorno: branco com borda e texto azul-marinho.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(46),
          backgroundColor: p.surface,
          foregroundColor: p.primary,
          side: BorderSide(color: p.primary),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 44),
          foregroundColor: p.primary,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // FAB laranja com ícone azul-marinho.
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.accent,
        foregroundColor: p.onAccent,
        shape: const CircleBorder(),
        elevation: 4,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.onSurface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(color: p.surface),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xxs,
        ),
        iconColor: p.onSurfaceMuted,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? p.onAccent : p.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? p.accent : p.outline,
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),

      // Bottom nav: Início + Perfil, ícone laranja quando ativo.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        indicatorColor: p.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(
          AppTypography.labelSmall.copyWith(
            letterSpacing: 0,
            fontSize: 12,
            color: p.onSurface,
          ),
        ),
      ),

      dividerTheme: DividerThemeData(color: p.outline, space: 1, thickness: 1),

      // Chips de status: pílula colorida por estado.
      chipTheme: ChipThemeData(
        backgroundColor: p.surface,
        side: BorderSide(color: p.outline),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
        labelStyle: AppTypography.labelSmall,
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: p.surface,
          foregroundColor: p.onSurfaceMuted,
          selectedBackgroundColor: p.primaryContainer,
          selectedForegroundColor: p.primary,
          side: BorderSide(color: p.outline),
          textStyle: AppTypography.bodyMedium,
          minimumSize: const Size.fromHeight(44),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
        ),
      ),
    );
  }
}
