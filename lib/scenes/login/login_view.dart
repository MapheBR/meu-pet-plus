import 'package:meupet_design_system/meupet_design_system.dart';
import 'package:flutter/material.dart';

import 'login_view_model.dart';

/// Login do MeuPet+: logo no topo, "Bem-vindo de volta", e-mail + senha
/// e o botão "Entrar" laranja — sem barra de app, como no protótipo.
/// Sem "esqueceu a senha"/"criar conta" — removidos do escopo.
class LoginView extends StatefulWidget {
  const LoginView({required this.viewModel, super.key});

  final LoginViewModel viewModel;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      padded: false,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Image.asset('assets/logo.png', width: 135)),
                const Gap.lg(),
                Text(
                  'Bem-vindo de volta',
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineMedium.copyWith(
                    color: scheme.primary,
                  ),
                ),
                const Gap.xs(),
                Text(
                  'Entre para cuidar da saúde dos seus pets',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const Gap.xl(),
                AppTextField(
                  key: const Key('login_email'),
                  label: 'E-mail',
                  hint: 'ana@email.com',
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.mail_outline,
                  onChanged: viewModel.onEmailChanged,
                ),
                const Gap.md(),
                AppTextField(
                  key: const Key('login_password'),
                  label: 'Senha',
                  hint: '••••••••',
                  obscureText: true,
                  icon: Icons.lock_outline,
                  onChanged: viewModel.onPasswordChanged,
                ),
                const Gap.lg(),
                // Só este trecho redesenha quando o ViewModel avisa mudança.
                ListenableBuilder(
                  listenable: viewModel,
                  builder: (context, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppButton.accent(
                        key: const Key('login_submit'),
                        label: 'Entrar',
                        isLoading: viewModel.isLoading,
                        onPressed: viewModel.submit,
                      ),
                      // No protótipo o erro aparece ABAIXO do botão.
                      if (viewModel.errorMessage
                          case final message?) ...[
                        const Gap.md(),
                        Text(
                          message,
                          key: const Key('login_error'),
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: context.semanticColors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Gap.xxl(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
