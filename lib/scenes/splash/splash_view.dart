import 'package:meupet_design_system/meupet_design_system.dart';
import 'package:flutter/material.dart';

import 'splash_view_model.dart';

/// Splash do MeuPet+: logo grande + slogan, sem barra de app —
/// o protótipo mostra só a marca centralizada enquanto a sessão
/// salva é verificada. Some sozinha quando o coordinator troca de tela.
class SplashView extends StatefulWidget {
  const SplashView({required this.viewModel, super.key});

  final SplashViewModel viewModel;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.start();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppScaffold(
      padded: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png', width: 190),
            const Gap.lg(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
              ),
              child: Text(
                'Amor, cuidado e carinho em cada patinha.',
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  color: scheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
