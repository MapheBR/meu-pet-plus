import 'package:flutter/material.dart';

import '../../app/app_navigator.dart';
import '../login/login_factory.dart';
import '../pet_detail/pet_detail_factory.dart';
import '../pet_form/pet_form_factory.dart';

/// Navigation out of the home scene.
abstract interface class HomeCoordinator {
  /// Session ended or expired.
  void goToLogin();

  /// "+" button of the pets tab. Completes with true when a pet was created.
  Future<bool> goToNewPet();

  /// Pet card tapped. Completes with true when something changed there.
  Future<bool> goToPetDetail(String id);
}

class DefaultHomeCoordinator implements HomeCoordinator {
  const DefaultHomeCoordinator({required this.onPetDetailExit});

  /// Avisa a ViewModel qual aba da Home mostrar depois que o detalhe
  /// do pet fecha pela bottom nav (0 = Início, 1 = Perfil).
  final void Function(int tab) onPetDetailExit;

  @override
  void goToLogin() => replaceRoot(LoginFactory.make());

  @override
  Future<bool> goToNewPet() async {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return false;
    final created = await navigator.push<bool>(
      MaterialPageRoute(builder: (_) => PetFormFactory.make()),
    );
    return created ?? false;
  }

  @override
  Future<bool> goToPetDetail(String id) async {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return false;
    final changed = await navigator.push<bool>(
      MaterialPageRoute(
        builder: (_) => PetDetailFactory.make(
          id,
          onGoHome: (tab) {
            navigator.pop();
            onPetDetailExit(tab);
          },
        ),
      ),
    );
    return changed ?? false;
  }
}
