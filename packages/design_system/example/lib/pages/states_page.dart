import 'package:flutter/material.dart';
import 'package:meupet_design_system/meupet_design_system.dart';

import '../main.dart';

/// Demonstra os três estados de lista do protótipo:
/// carregando (skeleton), vazio e erro.
class StatesPage extends StatefulWidget {
  const StatesPage({super.key});

  @override
  State<StatesPage> createState() => _StatesPageState();
}

class _StatesPageState extends State<StatesPage> {
  _DemoState _state = _DemoState.loaded;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Estados',
      actions: const [ThemeModeButton()],
      body: Column(
        children: [
          const SectionHeader(title: 'Trocar estado da lista'),
          SegmentedButton<_DemoState>(
            segments: const [
              ButtonSegment(
                value: _DemoState.loading,
                label: Text('Carregando'),
                icon: Icon(Icons.hourglass_top),
              ),
              ButtonSegment(
                value: _DemoState.empty,
                label: Text('Vazio'),
                icon: Icon(Icons.inbox_outlined),
              ),
              ButtonSegment(
                value: _DemoState.error,
                label: Text('Erro'),
                icon: Icon(Icons.error_outline),
              ),
              ButtonSegment(
                value: _DemoState.loaded,
                label: Text('Carregado'),
                icon: Icon(Icons.check_circle_outline),
              ),
            ],
            selected: {_state},
            onSelectionChanged: (s) => setState(() => _state = s.first),
          ),
          const Gap.md(),
          Expanded(child: _buildState()),
        ],
      ),
    );
  }

  Widget _buildState() {
    switch (_state) {
      case _DemoState.loading:
        return const StateView.loading();
      case _DemoState.empty:
        return StateView.empty(
          message: 'Nenhum pet cadastrado.\nCadastre o primeiro para '
              'acompanhar vacinas, consultas e peso.',
          actionLabel: 'Cadastrar pet',
          onAction: () {},
        );
      case _DemoState.error:
        return StateView.error(
          message: 'Não foi possível carregar os pets.\n'
              'Verifique a conexão e tente novamente.',
          onRetry: () => setState(() => _state = _DemoState.loaded),
        );
      case _DemoState.loaded:
        return ListView(
          children: const [
            PetCard(
              name: 'Thor',
              subtitle: 'Cachorro · Golden · 2 anos',
              status: StatusChip.warning(
                label: 'vacina pendente',
                icon: Icons.schedule,
              ),
            ),
            Gap.sm(),
            PetCard(
              name: 'Luna',
              subtitle: 'Gato · SRD · 8 meses',
              status: StatusChip.ok(
                label: 'tudo em dia',
                icon: Icons.check_circle,
              ),
            ),
          ],
        );
    }
  }
}

enum _DemoState { loading, empty, error, loaded }
