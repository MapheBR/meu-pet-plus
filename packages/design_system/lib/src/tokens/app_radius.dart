import 'package:flutter/painting.dart';

/// Corner radii do MeuPet+ (do protótipo: campos 10, cards/botões 12).
abstract final class AppRadius {
  static const double sm = 10; // campos de texto
  static const double md = 12; // cards, botões, chips grandes
  static const double lg = 16; // cards de destaque, modais
  static const double pill = 999; // chips de status, avatar

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}
