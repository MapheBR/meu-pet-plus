import 'package:flutter/material.dart';
import 'package:meupet_design_system/meupet_design_system.dart';

import 'pages/buttons_page.dart';
import 'pages/cards_page.dart';
import 'pages/chart_page.dart';
import 'pages/inputs_page.dart';
import 'pages/states_page.dart';
import 'pages/tokens_page.dart';

void main() => runApp(const GalleryApp());

/// Theme mode escolhido na galeria. Um [ValueNotifier] basta: um valor,
/// um listener, sem pacote de estado.
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: 'Galeria MeuPet+',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: mode,
        home: const GalleryHome(),
      ),
    );
  }
}

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  static final _pages = <({String title, IconData icon, Widget page})>[
    (title: 'Tokens', icon: Icons.palette_outlined, page: const TokensPage()),
    (title: 'Botões', icon: Icons.smart_button_outlined, page: const ButtonsPage()),
    (title: 'Campos', icon: Icons.edit_outlined, page: const InputsPage()),
    (title: 'Cards e chips', icon: Icons.style_outlined, page: const CardsPage()),
    (title: 'Gráfico', icon: Icons.show_chart, page: const ChartPage()),
    (title: 'Estados', icon: Icons.hourglass_empty, page: const StatesPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Galeria',
      showBrand: true,
      brandSubtitle: 'MeuPet+ Design System',
      actions: const [ThemeModeButton()],
      padded: false,
      body: ListView.separated(
        itemCount: _pages.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _pages[index];
          return ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => item.page),
            ),
          );
        },
      ),
    );
  }
}

/// Cicla system -> light -> dark.
class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        final icon = switch (mode) {
          ThemeMode.system => Icons.brightness_auto,
          ThemeMode.light => Icons.light_mode,
          ThemeMode.dark => Icons.dark_mode,
        };
        return IconButton(
          tooltip: 'Tema: ${mode.name}',
          icon: Icon(icon),
          onPressed: () {
            themeMode.value = switch (mode) {
              ThemeMode.system => ThemeMode.light,
              ThemeMode.light => ThemeMode.dark,
              ThemeMode.dark => ThemeMode.system,
            };
          },
        );
      },
    );
  }
}
