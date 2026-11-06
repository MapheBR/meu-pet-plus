import 'package:meupet_design_system/meupet_design_system.dart';
import 'package:flutter/material.dart';

import 'home_view_model.dart';

/// Home: aba "Meus pets" (cards com chip de saúde) e aba "Perfil",
/// trocadas pela [AppBottomNav] — só dois destinos, como no protótipo.
/// Não tem barra de app: o título "Meus pets" fica no corpo da tela.
class HomeView extends StatefulWidget {
  const HomeView({required this.viewModel, required this.profile, super.key});

  final HomeViewModel viewModel;

  /// A cena de perfil, já montada pela própria factory.
  final Widget profile;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.start();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => AppScaffold(
        padded: false,
        // IndexedStack mantém cada aba viva (scroll, estado).
        body: IndexedStack(
          index: viewModel.selectedTab,
          children: [_PetsTab(viewModel: viewModel), widget.profile],
        ),
        floatingActionButton: viewModel.selectedTab == 0
            ? FloatingActionButton(
                key: const Key('home_add_pet'),
                tooltip: 'Cadastrar pet',
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.navy,
                onPressed: viewModel.onAddPressed,
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: AppBottomNav(
          currentIndex: viewModel.selectedTab,
          onTap: viewModel.selectTab,
        ),
      ),
    );
  }
}

class _PetsTab extends StatelessWidget {
  const _PetsTab({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Cabeçalho "Meus pets" sempre visível; abaixo, um dos 3 estados
    // (carregando / vazio / erro) ou a lista de cards.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.md,
            AppSpacing.screen,
            AppSpacing.xs,
          ),
          child: Text(
            'Meus pets',
            style: AppTypography.titleLarge.copyWith(color: scheme.primary),
          ),
        ),
        Expanded(child: _content(context)),
      ],
    );
  }

  Widget _content(BuildContext context) {
    if (viewModel.errorMessage case final message?) {
      return StateView.error(message: message, onRetry: viewModel.retry);
    }
    if (viewModel.isLoading) {
      return const StateView.loading();
    }
    if (viewModel.pets.isEmpty) {
      return StateView.empty(
        message: 'Nenhum pet cadastrado',
        actionLabel: 'Cadastrar pet',
        onAction: () => viewModel.onAddPressed(),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        96,
      ),
      itemCount: viewModel.pets.length,
      separatorBuilder: (_, _) => const Gap.sm(),
      itemBuilder: (context, index) {
        final pet = viewModel.pets[index];
        return PetCard(
          name: pet.name,
          subtitle: pet.subtitle,
          status: _chipFor(pet.health, pet.healthLabel),
          onTap: () => viewModel.onPetTapped(pet.id),
        );
      },
    );
  }

  Widget _chipFor(PetHealth health, String label) => switch (health) {
    PetHealth.ok => StatusChip.ok(label: label),
    PetHealth.warning => StatusChip.warning(label: label),
    PetHealth.overdue => StatusChip.error(label: label),
    PetHealth.none => StatusChip(label: label, status: AppStatus.neutral),
  };
}
