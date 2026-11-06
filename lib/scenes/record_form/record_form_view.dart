import 'package:meupet_core/meupet_core.dart';
import 'package:meupet_design_system/meupet_design_system.dart';
import 'package:flutter/material.dart';

import 'record_form_view_model.dart';
import 'record_kind.dart';

/// Formulário de registro do pet (vacina, consulta ou peso).
/// Os três tipos compartilham o mesmo padrão do protótipo: rótulos acima
/// dos campos, datas via date picker e só o botão "Salvar" no rodapé.
class RecordFormView extends StatefulWidget {
  const RecordFormView({required this.viewModel, super.key});

  final RecordFormViewModel viewModel;

  @override
  State<RecordFormView> createState() => _RecordFormViewState();
}

class _RecordFormViewState extends State<RecordFormView> {
  // Um controller por campo de data (somente-leitura, texto vem do VM).
  final _applicationDateCtrl = TextEditingController();
  final _nextDueDateCtrl = TextEditingController();
  final _consultationDateCtrl = TextEditingController();
  final _weightDateCtrl = TextEditingController();

  @override
  void dispose() {
    widget.viewModel.dispose();
    _applicationDateCtrl.dispose();
    _nextDueDateCtrl.dispose();
    _consultationDateCtrl.dispose();
    _weightDateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(
    DateTime? current,
    ValueChanged<DateTime> onPicked, {
    bool allowFuture = false,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(1990),
      lastDate: allowFuture ? DateTime(now.year + 10) : now,
      helpText: 'Selecione a data',
    );
    if (picked != null) onPicked(picked);
  }

  String _dateText(DateTime? date) =>
      date == null ? '' : formatDateBr(date);

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final textTheme = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        // Sincroniza os campos de data somente-leitura com o ViewModel.
        _applicationDateCtrl.text = _dateText(viewModel.applicationDate);
        _nextDueDateCtrl.text = _dateText(viewModel.nextDueDate);
        _consultationDateCtrl.text = _dateText(viewModel.consultationDate);
        _weightDateCtrl.text = _dateText(viewModel.weightDate);

        return AppScaffold(
          title: viewModel.kind.title,
          // Botão fixo no rodapé (como o `.ft` do protótipo): o scroll
          // fica só com os campos.
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._fields(viewModel),
                      if (viewModel.errorMessage
                          case final message?) ...[
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
                key: const Key('record_save'),
                label: viewModel.kind.saveLabel,
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

  List<Widget> _fields(RecordFormViewModel viewModel) {
    Widget dateField({
      required Key key,
      required String label,
      required TextEditingController controller,
      required DateTime? value,
      required ValueChanged<DateTime> onPicked,
      required IconData icon,
      String? errorText,
      bool allowFuture = false,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: AppTextField(
          key: key,
          label: label,
          hint: 'dd/mm/aaaa',
          controller: controller,
          icon: icon,
          readOnly: true,
          errorText: errorText,
          onTap: () => _pickDate(value, onPicked, allowFuture: allowFuture),
        ),
      );
    }

    return switch (viewModel.kind) {
      RecordKind.vaccine => [
        AppTextField(
          key: const Key('vaccine_name'),
          label: 'Nome da vacina',
          hint: 'Ex.: V10',
          icon: Icons.vaccines,
          errorText: viewModel.fieldError('name'),
          onChanged: viewModel.onNameChanged,
        ),
        const Gap.lg(),
        dateField(
          key: const Key('vaccine_application_date'),
          label: 'Data de aplicação',
          controller: _applicationDateCtrl,
          value: viewModel.applicationDate,
          icon: Icons.calendar_month,
          errorText: viewModel.fieldError('applicationDate'),
          onPicked: viewModel.onApplicationDateChanged,
        ),
        dateField(
          key: const Key('vaccine_next_due'),
          label: 'Próxima dose',
          controller: _nextDueDateCtrl,
          value: viewModel.nextDueDate,
          icon: Icons.event_repeat,
          errorText: viewModel.fieldError('nextDueDate'),
          onPicked: viewModel.onNextDueDateChanged,
          allowFuture: true,
        ),
        AppTextField(
          key: const Key('vaccine_vet'),
          label: 'Veterinário (opcional)',
          hint: 'Nome do profissional',
          icon: Icons.person_outline,
          onChanged: viewModel.onVeterinarianChanged,
        ),
        const Gap.lg(),
        AppTextField(
          key: const Key('vaccine_notes'),
          label: 'Observações (opcional)',
          hint: 'Escreva aqui',
          icon: Icons.sticky_note_2_outlined,
          maxLines: 3,
          onChanged: viewModel.onNotesChanged,
        ),
      ],
      RecordKind.consultation => [
        dateField(
          key: const Key('consultation_date'),
          label: 'Data',
          controller: _consultationDateCtrl,
          value: viewModel.consultationDate,
          icon: Icons.calendar_month,
          errorText: viewModel.fieldError('date'),
          onPicked: viewModel.onConsultationDateChanged,
        ),
        AppTextField(
          key: const Key('consultation_vet'),
          label: 'Veterinário',
          hint: 'Nome do veterinário',
          icon: Icons.person_outline,
          errorText: viewModel.fieldError('veterinarian'),
          onChanged: viewModel.onVeterinarianChanged,
        ),
        const Gap.lg(),
        AppTextField(
          key: const Key('consultation_reason'),
          label: 'Motivo',
          hint: 'Ex.: Check-up anual',
          icon: Icons.medical_services_outlined,
          errorText: viewModel.fieldError('reason'),
          onChanged: viewModel.onReasonChanged,
        ),
        const Gap.lg(),
        AppTextField(
          key: const Key('consultation_notes'),
          label: 'Observações (opcional)',
          hint: 'Anotações da consulta',
          icon: Icons.sticky_note_2_outlined,
          maxLines: 3,
          onChanged: viewModel.onNotesChanged,
        ),
      ],
      RecordKind.weight => [
        dateField(
          key: const Key('weight_date'),
          label: 'Data',
          controller: _weightDateCtrl,
          value: viewModel.weightDate,
          icon: Icons.calendar_month,
          errorText: viewModel.fieldError('date'),
          onPicked: viewModel.onWeightDateChanged,
        ),
        AppTextField(
          key: const Key('weight_kg'),
          label: 'Peso (kg)',
          hint: 'Ex.: 12,5',
          icon: Icons.monitor_weight,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          errorText: viewModel.fieldError('weightKg'),
          onChanged: viewModel.onWeightChanged,
        ),
      ],
    };
  }
}
