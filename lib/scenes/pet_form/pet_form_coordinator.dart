import '../../app/app_navigator.dart';

/// Navigation out of the pet form scene.
abstract interface class PetFormCoordinator {
  /// Volta para a tela anterior. [created] diz se um pet foi salvo
  /// (a Home recarrega a lista nesse caso).
  void goBack({required bool created});
}

class DefaultPetFormCoordinator implements PetFormCoordinator {
  @override
  void goBack({required bool created}) {
    appNavigatorKey.currentState?.pop(created);
  }
}
