import 'package:meupet_core/meupet_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;

import '../../app/theme_mode_button.dart';
import 'profile_coordinator.dart';
import 'server_profile.dart';

/// State and actions of the profile scene ("Perfil" tab).
///
/// Notificações e tema são ajustes LOCAIS do app (protótipo): não vão
/// para a API — o tema usa o [appThemeMode] compartilhado do app.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required this._server, required this._coordinator});

  final ServerProfile _server;
  final ProfileCoordinator _coordinator;

  User? _user;
  bool _isLoading = false;
  bool _isLoggingOut = false;
  String? _errorMessage;
  bool _notificationsEnabled = true;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  bool get isLoggingOut => _isLoggingOut;
  String? get errorMessage => _errorMessage;
  bool get notificationsEnabled => _notificationsEnabled;

  // Header: mostra o que está salvo na API.
  String get name => _user?.name ?? '';
  String get email => _user?.email ?? '';

  /// "Na MeuPet+ desde dd/mm/aaaa".
  String get memberSince => _user == null
      ? ''
      : 'Na MeuPet+ desde ${formatDateBr(_user!.createdAt)}';

  /// Tema escuro ligado? (lê o ValueNotifier global do app)
  bool get isDarkTheme => appThemeMode.value == ThemeMode.dark;

  // ── Actions ──────────────────────────────────────────────────────────────

  Future<void> start() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _server.fetchProfile();
    _isLoading = false;
    switch (result) {
      case Ok(:final value):
        _user = value;
        notifyListeners();
      case Failure(error: UnauthorizedError()):
        await logout();
      case Failure(:final error):
        _errorMessage = error.message;
        notifyListeners();
    }
  }

  /// Switch "Notificações" — ajuste local, sem chamada à API.
  void onNotificationsChanged(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  /// Switch "Tema claro/escuro" — alterna o tema global do app.
  void onThemeChanged(bool dark) {
    appThemeMode.value = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// "Sair da conta".
  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    notifyListeners();
    await _server.logout();
    _coordinator.goToLogin();
  }

  /// Answers can arrive after the screen closed; ignore them then.
  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
