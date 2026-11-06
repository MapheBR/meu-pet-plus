import 'package:flutter/widgets.dart';

import '../profile/profile_factory.dart';
import 'home_coordinator.dart';
import 'home_view.dart';
import 'home_view_model.dart';
import 'server_home.dart';

/// Assembles the home scene, injecting its dependencies into the ViewModel.
/// The "Perfil" tab is its own scene, built by [ProfileFactory].
abstract final class HomeFactory {
  static Widget make() {
    // O coordinator precisa avisar a ViewModel qual aba mostrar quando o
    // detalhe do pet volta pela bottom nav — daí o `late` (callback roda
    // depois, quando o viewModel já existe).
    late final HomeViewModel viewModel;
    final coordinator = DefaultHomeCoordinator(
      onPetDetailExit: (tab) => viewModel.selectTab(tab),
    );
    viewModel = HomeViewModel(
      serverHome: HomeServer(),
      coordinator: coordinator,
    );
    return HomeView(viewModel: viewModel, profile: ProfileFactory.make());
  }
}
