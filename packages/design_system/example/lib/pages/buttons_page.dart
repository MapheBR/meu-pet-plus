import 'package:flutter/material.dart';
import 'package:meupet_design_system/meupet_design_system.dart';

import '../main.dart';

class ButtonsPage extends StatefulWidget {
  const ButtonsPage({super.key});

  @override
  State<ButtonsPage> createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  bool _loading = false;

  Future<void> _simulate() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Botões',
      actions: const [ThemeModeButton()],
      body: ListView(
        children: [
          const SectionHeader(title: 'Primary (azul-marinho)'),
          AppButton(label: 'Salvar', onPressed: () {}),
          const Gap.sm(),
          AppButton(label: 'Com ícone', icon: Icons.add, onPressed: () {}),
          const Gap.sm(),
          const AppButton(label: 'Desabilitado', onPressed: null),
          const Gap.sm(),
          AppButton(
            label: 'Toque para carregar',
            isLoading: _loading,
            onPressed: _simulate,
          ),
          const SectionHeader(title: 'Accent (laranja — CTA)'),
          AppButton.accent(label: 'Entrar', icon: Icons.login, onPressed: () {}),
          const Gap.sm(),
          AppButton.accent(label: 'Salvar vacina', onPressed: () {}),
          const SectionHeader(title: 'Secondary / Danger / Text'),
          AppButton.secondary(label: 'Cancelar', onPressed: () {}),
          const Gap.sm(),
          AppButton.danger(label: 'Sair', icon: Icons.logout, onPressed: () {}),
          const Gap.sm(),
          Row(
            children: [
              AppButton.text(label: 'Esqueci a senha', onPressed: () {}),
              const Gap.sm(),
              AppButton.text(
                label: 'Tentar novamente',
                icon: Icons.refresh,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
