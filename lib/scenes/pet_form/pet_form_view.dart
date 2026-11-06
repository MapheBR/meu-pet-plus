import 'package:meupet_core/meupet_core.dart';
import 'package:meupet_design_system/meupet_design_system.dart';
import 'package:flutter/material.dart';

import 'pet_form_view_model.dart';

/// Formulário "Novo pet": nome, espécie (chips), raça e nascimento.
/// Só o botão "Salvar" no rodapé — sem ✓ na barra (regra do protótipo).
class PetFormView extends StatefulWidget {
  const PetFormView({required this.viewModel, super.key});

  final PetFormViewModel viewModel;

  @override
  State<PetFormView> createState() => _PetFormViewState();
}

class _PetFormViewState extends State<PetFormView> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _birthController = TextEditingController();

  @override
  void dispose() {
    widget.viewModel.dispose();
    _nameController.dispose();
    _breedController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final viewModel = widget.viewModel;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: viewModel.birthDate ?? DateTime(now.year - 1, now.month),
      firstDate: DateTime(1990),
      lastDate: now,
      helpText: 'Data de nascimento',
    );
    if (picked != null) viewModel.onBirthDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        // Campo de data é somente-leitura: o texto vem do ViewModel.
        _birthController.text = viewModel.birthDate == null
            ? ''
            : formatDateBr(viewModel.birthDate!);

        return AppScaffold(
          title: 'Novo pet',
          // Botão fixo no rodapé (como o `.ft` do protótipo).
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        key: const Key('pet_name'),
                        label: 'Nome',
                        hint: 'Ex.: Thor',
                        controller: _nameController,
                        icon: Icons.pets,
                        textCapitalization: TextCapitalization.words,
                        errorText: viewModel.fieldError('name'),
                        onChanged: viewModel.onNameChanged,
                      ),
                      const Gap.lg(),
                      Text('Espécie', style: AppTypography.labelSmall),
                      const Gap.xs(),
                      AppChoiceChips(
                        options: [
                          for (final s in PetFormViewModel.speciesOptions)
                            s.label,
                        ],
                        selectedIndex: PetFormViewModel.speciesOptions
                            .indexOf(viewModel.species),
                        onSelected: viewModel.onSpeciesSelected,
                      ),
                      const Gap.lg(),
                      AppTextField(
                        key: const Key('pet_breed'),
                        label: 'Raça',
                        hint: 'Ex.: Golden Retriever',
                        controller: _breedController,
                        icon: Icons.category_outlined,
                        errorText: viewModel.fieldError('breed'),
                        onChanged: viewModel.onBreedChanged,
                      ),
                      const Gap.lg(),
                      AppTextField(
                        key: const Key('pet_birth_date'),
                        label: 'Data de nascimento',
                        hint: 'dd/mm/aaaa',
                        controller: _birthController,
                        icon: Icons.cake_outlined,
                        readOnly: true,
                        onTap: _pickBirthDate,
                      ),
                      if (viewModel.fieldError('birthDate')
                          case final error?) ...[
                        const Gap.xs(),
                        Text(
                          error,
                          style: textTheme.bodySmall?.copyWith(
                            color: context.semanticColors.error,
                          ),
                        ),
                      ],
                      if (viewModel.errorMessage case final message?) ...[
                        const Gap.md(),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: context.semanticColors.error,
                          ),
                        ),
                      ],
                      const Gap.md(),
                    ],
                  ),
                ),
              ),
              const Gap.sm(),
              AppButton.accent(
                key: const Key('pet_save'),
                label: 'Salvar pet',
                isLoading: viewModel.isLoading,
                onPressed: viewModel.save,
              ),
              const Gap.sm(),
            ],
          ),
        );
      },
    );
  }
}
