import 'package:meupet_design_system/meupet_design_system.dart';
import 'package:flutter/material.dart';

import 'profile_view_model.dart';

/// "Perfil" tab: título, cartão do usuário (avatar + nome + e-mail),
/// ajustes locais em cartões (Lembretes de vacina e Tema escuro) e o
/// botão "Sair" fixo no rodapé — como no protótipo.
/// Sem edição de dados — a API não tem PUT /me.
class ProfileView extends StatefulWidget {
  const ProfileView({required this.viewModel, super.key});

  final ProfileViewModel viewModel;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
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
    final scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) return const StateView.loading();
        if (viewModel.errorMessage case final message?) {
          return StateView.error(message: message, onRetry: viewModel.start);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho "Perfil" + conteúdo com rolagem.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.md,
                  AppSpacing.screen,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Perfil',
                      style: AppTypography.titleLarge.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                    const Gap.md(),
                    _UserCard(viewModel: viewModel),
                    const Gap.md(),
                    SettingsTile(
                      icon: Icons.notifications_active_outlined,
                      title: 'Lembretes de vacina',
                      value: viewModel.notificationsEnabled,
                      onChanged: viewModel.onNotificationsChanged,
                    ),
                    const Gap.sm(),
                    SettingsTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Tema escuro',
                      value: viewModel.isDarkTheme,
                      onChanged: viewModel.onThemeChanged,
                    ),
                    const Gap.md(),
                  ],
                ),
              ),
            ),
            // "Sair" fixo no rodapé, acima da bottom nav (protótipo `.ft`).
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.sm,
              ),
              child: AppButton.danger(
                key: const Key('profile_logout'),
                label: 'Sair',
                icon: Icons.logout,
                isLoading: viewModel.isLoggingOut,
                onPressed: viewModel.logout,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Cartão do usuário: avatar com ícone de pessoa, nome e e-mail.
class _UserCard extends StatelessWidget {
  const _UserCard({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          AppAvatar(icon: Icons.person, size: 48),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.name,
                  style: AppTypography.titleSmall.copyWith(
                    color: scheme.primary,
                  ),
                ),
                Text(
                  viewModel.email,
                  style: AppTypography.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
