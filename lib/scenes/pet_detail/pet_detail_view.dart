import 'package:meupet_core/meupet_core.dart';
import 'package:meupet_design_system/meupet_design_system.dart';
import 'package:flutter/material.dart';

import 'pet_detail_view_model.dart';

/// Detalhe do pet: barra interna com voltar + nome do pet, abas
/// Resumo / Vacinas / Consultas / Peso e a bottom nav (o protótipo a
/// mostra também nas telas de detalhe). O "+" aparece só nas abas de lista.
class PetDetailView extends StatefulWidget {
  const PetDetailView({required this.viewModel, super.key});

  final PetDetailViewModel viewModel;

  @override
  State<PetDetailView> createState() => _PetDetailViewState();
}

class _PetDetailViewState extends State<PetDetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: PetTabs.labels.length, vsync: this);
    _tabs.addListener(_onTabChanged);
    widget.viewModel.start();
  }

  void _onTabChanged() {
    if (_tabs.indexIsChanging) return;
    widget.viewModel.selectTab(_tabs.index);
  }

  @override
  void dispose() {
    _tabs.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final Widget body;
        if (viewModel.errorMessage case final message?) {
          body = StateView.error(message: message, onRetry: viewModel.retry);
        } else if (viewModel.pet == null) {
          body = const StateView.loading();
        } else {
          body = Column(
            children: [
              PetTabs(controller: _tabs),
              Expanded(
                child: TabBarView(
                  controller: _tabs,
                  children: [
                    _ResumoTab(viewModel: viewModel),
                    _VaccinesTab(viewModel: viewModel),
                    _ConsultationsTab(viewModel: viewModel),
                    _WeightsTab(viewModel: viewModel),
                  ],
                ),
              ),
            ],
          );
        }

        return AppScaffold(
          title: viewModel.petTitle,
          padded: false,
          body: body,
          floatingActionButton: viewModel.selectedTab > 0
              ? FloatingActionButton(
                  key: const Key('pet_add_record'),
                  tooltip: 'Adicionar registro',
                  backgroundColor: AppColors.orange,
                  foregroundColor: AppColors.navy,
                  onPressed: viewModel.onAddPressed,
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: AppBottomNav(
            currentIndex: 0,
            onTap: viewModel.onNavTap,
          ),
        );
      },
    );
  }
}

/// Cartão do pet que abre a aba Resumo: avatar grande, nome e
/// "Raça · idade · peso" (protótipo).
class _PetHeaderCard extends StatelessWidget {
  const _PetHeaderCard({required this.viewModel});

  final PetDetailViewModel viewModel;

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
          AppAvatar(icon: Icons.pets, size: 56),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.petTitle,
                  style: AppTypography.titleLarge.copyWith(
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  viewModel.petHeaderSubtitle,
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

/// Aba Resumo: cartão do pet + três [InfoCard] — vacina, consulta e peso.
class _ResumoTab extends StatelessWidget {
  const _ResumoTab({required this.viewModel});

  final PetDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        _PetHeaderCard(viewModel: viewModel),
        const Gap.md(),
        InfoCard(
          icon: Icons.vaccines,
          title: viewModel.vaccineCard.title,
          subtitle: viewModel.vaccineCard.subtitle,
        ),
        const Gap.md(),
        InfoCard(
          icon: Icons.medical_services,
          title: viewModel.consultationCard.title,
          subtitle: viewModel.consultationCard.subtitle,
        ),
        const Gap.md(),
        InfoCard(
          icon: Icons.monitor_weight,
          title: viewModel.weightCard.title,
          subtitle: viewModel.weightCard.subtitle,
        ),
        const Gap.xl(),
      ],
    );
  }
}

/// Aba Vacinas: uma [InfoCard] por vacina, com chip de status.
class _VaccinesTab extends StatelessWidget {
  const _VaccinesTab({required this.viewModel});

  final PetDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.vaccines.isEmpty) {
      return const StateView.empty(
        message: 'Nenhuma vacina registrada',
        icon: Icons.vaccines,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.md,
        AppSpacing.screen,
        96,
      ),
      itemCount: viewModel.vaccines.length,
      separatorBuilder: (_, _) => const Gap.sm(),
      itemBuilder: (context, index) {
        final vaccine = viewModel.vaccines[index];
        final status = vaccineStatusOf(
          vaccine.nextDueDate,
          now: DateTime.now(),
        );
        return InfoCard(
          icon: Icons.vaccines,
          title: vaccine.name,
          subtitle:
              'Aplicada em ${formatDateBr(vaccine.applicationDate)} · '
              'próxima em ${formatDateBr(vaccine.nextDueDate)}',
          trailing: _chip(status, vaccine.nextDueDate),
        );
      },
    );
  }

  /// Chip do protótipo: "Em dia", "Vence em 15 dias", "Vencida".
  Widget _chip(VaccineStatus status, DateTime nextDueDate) {
    final days = vaccineDaysUntil(nextDueDate);
    return switch (status) {
      VaccineStatus.upToDate => const StatusChip.ok(label: 'Em dia'),
      VaccineStatus.dueSoon => StatusChip.warning(
        label: 'Vence em $days dias',
        icon: Icons.schedule,
      ),
      VaccineStatus.overdue => const StatusChip.error(label: 'Vencida'),
    };
  }
}

/// Aba Consultas: motivo, data · veterinário e observações,
/// da mais recente à mais antiga.
class _ConsultationsTab extends StatelessWidget {
  const _ConsultationsTab({required this.viewModel});

  final PetDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.consultations.isEmpty) {
      return const StateView.empty(
        message: 'Nenhuma consulta registrada',
        icon: Icons.medical_services,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.md,
        AppSpacing.screen,
        96,
      ),
      itemCount: viewModel.consultations.length,
      separatorBuilder: (_, _) => const Gap.sm(),
      itemBuilder: (context, index) {
        final consultation = viewModel.consultations[index];
        final notes = consultation.notes;
        return InfoCard(
          icon: Icons.medical_services,
          title: consultation.reason,
          subtitle:
              '${formatDateBr(consultation.date)} · ${consultation.veterinarian}'
              '${notes == null || notes.isEmpty ? '' : '\n$notes'}',
        );
      },
    );
  }
}

/// Aba Peso: card com o último peso + chip de variação, gráfico de linha
/// e card "Histórico" com todos os registros.
class _WeightsTab extends StatelessWidget {
  const _WeightsTab({required this.viewModel});

  final PetDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final weights = viewModel.weights;
    if (weights.isEmpty) {
      return const StateView.empty(
        message: 'Nenhum peso registrado',
        icon: Icons.monitor_weight,
      );
    }
    final last = weights.last;
    final kg = last.weightKg.toStringAsFixed(1).replaceAll('.', ',');
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.md,
        AppSpacing.screen,
        96,
      ),
      children: [
        // Card "28,4 kg · Último registro…" + chip de variação.
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: scheme.outline),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$kg kg',
                      style: AppTypography.headlineMedium.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                    if (viewModel.weightLastRecordText case final text?)
                      Text(
                        text,
                        style: AppTypography.bodySmall.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (viewModel.weightVariationChip case final chip?)
                StatusChip.ok(label: chip, icon: Icons.trending_up),
            ],
          ),
        ),
        const Gap.md(),
        if (weights.length >= 2) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: WeightChart(
                points: [
                  for (final w in weights)
                    WeightPoint(date: w.date, kg: w.weightKg),
                ],
              ),
            ),
          ),
          const Gap.md(),
        ],
        InfoCard(
          icon: Icons.monitor_weight,
          title: 'Histórico',
          subtitle: [
            for (final w in weights.reversed)
              '${formatDateBr(w.date).substring(0, 5)} — '
              '${w.weightKg.toStringAsFixed(1).replaceAll('.', ',')} kg',
          ].join('\n'),
        ),
        const Gap.xl(),
      ],
    );
  }
}
