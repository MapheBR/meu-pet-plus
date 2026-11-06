import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import '../login/login_factory.dart';
import '../record_form/record_form_factory.dart';
import '../record_form/record_kind.dart';

/// Navigation out of the pet detail scene.
abstract interface class PetDetailCoordinator {
  /// Session ended or expired.
  void goToLogin();

  /// "+" button of the Vacinas/Consultas/Peso tabs.
  /// Completes with true when a record was created.
  Future<bool> goToNewRecord(RecordKind kind);

  /// Bottom nav (Início/Perfil): volta à Home já na aba escolhida.
  void goToHome(int tab);

  void showMessage(String message);
}

class DefaultPetDetailCoordinator implements PetDetailCoordinator {
  const DefaultPetDetailCoordinator({
    required this.petId,
    required this.onGoHome,
  });

  final String petId;

  /// Chamado pela Home para voltar e já selecionar a aba [tab].
  final void Function(int tab) onGoHome;

  @override
  void goToLogin() => replaceRoot(LoginFactory.make());

  @override
  Future<bool> goToNewRecord(RecordKind kind) async {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return false;
    final created = await navigator.push<bool>(
      MaterialPageRoute(
        builder: (_) => RecordFormFactory.make(kind, petId),
      ),
    );
    return created ?? false;
  }

  @override
  void goToHome(int tab) => onGoHome(tab);

  @override
  void showMessage(String message) => showAppMessage(message);
}
