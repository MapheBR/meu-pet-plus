import 'package:flutter/material.dart';
import 'package:meupet_design_system/meupet_design_system.dart';

import '../main.dart';

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  int _species = 0;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Campos',
      actions: const [ThemeModeButton()],
      body: ListView(
        children: [
          const SectionHeader(title: 'AppTextField (rótulo acima)'),
          AppTextField(
            label: 'Nome da vacina',
            hint: 'Ex.: V10',
            icon: Icons.vaccines,
          ),
          const Gap.sm(),
          AppTextField(
            label: 'Data de aplicação',
            hint: 'dd/mm/aaaa',
            icon: Icons.calendar_month,
          ),
          const Gap.sm(),
          AppTextField(
            label: 'Senha',
            hint: '••••••••',
            icon: Icons.lock_outline,
            obscureText: true,
          ),
          const Gap.sm(),
          AppTextField(
            label: 'Observações (opcional)',
            hint: 'Texto livre…',
            icon: Icons.notes,
            maxLines: 3,
          ),
          const SectionHeader(title: 'AppChoiceChips (espécie)'),
          AppTextField(
            label: 'Espécie',
            hint: '',
            enabled: false,
            controller: TextEditingController(
              text: _species == 0 ? 'Cachorro' : 'Gato',
            ),
          ),
          const Gap.sm(),
          AppChoiceChips(
            options: const ['Cachorro', 'Gato'],
            selectedIndex: _species,
            onSelected: (i) => setState(() => _species = i),
          ),
          const SectionHeader(title: 'Validação'),
          _ValidatedField(),
        ],
      ),
    );
  }
}

class _ValidatedField extends StatefulWidget {
  @override
  State<_ValidatedField> createState() => _ValidatedFieldState();
}

class _ValidatedFieldState extends State<_ValidatedField> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Peso (kg)',
            hint: 'Ex.: 28,4',
            icon: Icons.monitor_weight,
            keyboardType: TextInputType.number,
            controller: _controller,
            validator: (v) {
              final n = double.tryParse((v ?? '').replaceAll(',', '.'));
              if (n == null || n <= 0) return 'Informe um peso válido';
              return null;
            },
          ),
          const Gap.sm(),
          AppButton(
            label: 'Validar',
            onPressed: () => _formKey.currentState!.validate(),
          ),
        ],
      ),
    );
  }
}
