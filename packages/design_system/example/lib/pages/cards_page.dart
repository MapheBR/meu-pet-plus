import 'package:flutter/material.dart';
import 'package:meupet_design_system/meupet_design_system.dart';

import '../main.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  bool _notifications = true;
  bool _darkTheme = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Cards e chips',
      actions: const [ThemeModeButton()],
      body: ListView(
        children: [
          const SectionHeader(title: 'PetCard (Home)'),
          PetCard(
            name: 'Thor',
            subtitle: 'Cachorro · Golden · 2 anos',
            status: StatusChip.error(
              label: 'vacina vencida',
              icon: Icons.vaccines,
            ),
            onTap: () {},
          ),
          const Gap.sm(),
          PetCard(
            name: 'Luna',
            subtitle: 'Gato · SRD · 8 meses',
            status: StatusChip.ok(
              label: 'tudo em dia',
              icon: Icons.check_circle,
            ),
            onTap: () {},
          ),
          const SectionHeader(title: 'StatusChip — 3 estados + neutro'),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: const [
              StatusChip.ok(label: 'Em dia', icon: Icons.check_circle),
              StatusChip.warning(
                label: 'Vence em breve',
                icon: Icons.schedule,
              ),
              StatusChip.error(label: 'Vencida', icon: Icons.error),
              StatusChip(label: 'Neutro', status: AppStatus.neutral),
            ],
          ),
          const SectionHeader(title: 'InfoCard (Visão geral do pet)'),
          InfoCard(
            icon: Icons.vaccines,
            title: 'Vacinas — atenção',
            subtitle: 'V8 vencida há 56 dias · V10 vence em 15 dias',
            trailing: StatusChip.error(label: '1 vencida'),
            highlighted: true,
          ),
          const Gap.sm(),
          InfoCard(
            icon: Icons.medical_services_outlined,
            title: 'Última consulta',
            subtitle: '28/10/2026 · Dra. Camila Ribeiro · Rotina',
          ),
          const Gap.sm(),
          InfoCard(
            icon: Icons.monitor_weight_outlined,
            title: 'Peso',
            subtitle: '28,4 kg · +0,5 kg nos últimos 5 meses',
          ),
          const SectionHeader(title: 'PetTabs (detalhe do pet)'),
          _TabsDemo(),
          const SectionHeader(title: 'SettingsTile (Perfil)'),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Column(
              children: [
                SettingsTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Notificações de vacina',
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
                SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Tema escuro',
                  subtitle: 'Ainda não disponível',
                  value: _darkTheme,
                  onChanged: (v) => setState(() => _darkTheme = v),
                ),
              ],
            ),
          ),
          const Gap.sm(),
          const SectionHeader(title: 'MenuActionTile'),
          MenuActionTile(
            icon: Icons.logout,
            label: 'Sair',
            danger: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

/// Demonstra as 4 abas do detalhe do pet com conteúdo fake.
class _TabsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: PetTabs.labels.length,
      child: Column(
        children: [
          Builder(
            builder: (context) =>
                PetTabs(controller: DefaultTabController.of(context)),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 120,
            child: TabBarView(
              children: [
                for (final label in PetTabs.labels)
                  Center(child: Text('Conteúdo de $label')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
