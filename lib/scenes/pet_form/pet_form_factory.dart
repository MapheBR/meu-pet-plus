import 'package:flutter/widgets.dart';

import 'pet_form_coordinator.dart';
import 'pet_form_view.dart';
import 'pet_form_view_model.dart';
import 'server_pet_form.dart';

/// Assembles the pet form scene, injecting its dependencies into the ViewModel.
abstract final class PetFormFactory {
  static Widget make() {
    final viewModel = PetFormViewModel(
      server: PetFormServer(),
      coordinator: DefaultPetFormCoordinator(),
    );
    return PetFormView(viewModel: viewModel);
  }
}
