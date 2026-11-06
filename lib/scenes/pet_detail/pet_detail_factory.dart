import 'package:flutter/widgets.dart';

import 'pet_detail_coordinator.dart';
import 'pet_detail_view.dart';
import 'pet_detail_view_model.dart';
import 'server_pet_detail.dart';

/// Assembles the pet detail scene for [petId], injecting dependencies.
/// [onGoHome] é chamado pela bottom nav do detalhe para voltar à Home
/// já com a aba certa selecionada (0 = Início, 1 = Perfil).
abstract final class PetDetailFactory {
  static Widget make(String petId, {required void Function(int tab) onGoHome}) {
    final viewModel = PetDetailViewModel(
      petId: petId,
      server: PetDetailServer(),
      coordinator: DefaultPetDetailCoordinator(
        petId: petId,
        onGoHome: onGoHome,
      ),
    );
    return PetDetailView(viewModel: viewModel);
  }
}
