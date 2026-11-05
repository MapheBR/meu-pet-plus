/// Spacing scale on a 4pt grid (múltiplos de 4/8, como no protótipo).
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Default horizontal padding of screens.
  static const double screen = md;

  /// Altura mínima de toque (acessibilidade).
  static const double minTouchTarget = 44;
}
