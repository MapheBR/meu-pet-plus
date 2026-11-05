import 'package:flutter/material.dart';

/// Type scale do MeuPet+: Poppins para títulos/marca, Inter para texto.
///
/// Regras do protótipo: mínimo 12px para texto, 14px+ para títulos.
/// As fontes são empacotadas neste pacote (package: 'meupet_design_system').
abstract final class AppTypography {
  static const String titleFont = 'Poppins';
  static const String bodyFont = 'Inter';
  static const String fontPackage = 'meupet_design_system';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: titleFont,
    package: fontPackage,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: titleFont,
    package: fontPackage,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  static const TextStyle titleLarge = TextStyle(
    fontFamily: titleFont,
    package: fontPackage,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: titleFont,
    package: fontPackage,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static const TextStyle titleSmall = TextStyle(
    fontFamily: titleFont,
    package: fontPackage,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    package: fontPackage,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    package: fontPackage,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFont,
    package: fontPackage,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: titleFont,
    package: fontPackage,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  static const TextStyle labelSmall = TextStyle(
    fontFamily: bodyFont,
    package: fontPackage,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelSmall: labelSmall,
  );
}
