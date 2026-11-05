import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Abas do detalhe do pet: Resumo / Vacinas / Consultas / Peso.
///
/// Usar dentro de um [DefaultTabController] ou com [TabController].
/// Indicador laranja, texto azul-marinho na aba ativa (protótipo).
class PetTabs extends StatelessWidget implements PreferredSizeWidget {
  const PetTabs({super.key, required this.controller});

  final TabController controller;

  static const List<String> labels = [
    'Resumo',
    'Vacinas',
    'Consultas',
    'Peso',
  ];

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TabBar(
      controller: controller,
      tabs: [for (final label in labels) Tab(text: label)],
      labelColor: scheme.primary,
      unselectedLabelColor: scheme.onSurfaceVariant,
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: Theme.of(context).textTheme.labelSmall,
      indicatorColor: AppColors.orange,
      indicatorWeight: 3,
      dividerColor: scheme.outline,
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
