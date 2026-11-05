import 'package:flutter/material.dart';

import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';
import 'gap.dart';

/// Scaffold do design system com dois tipos de barra:
///
/// - **Marca** (`showBrand: true`): usado em Splash, Login e Home —
///   app bar azul-marinho com logo + nome do app.
/// - **Interna** (padrão): voltar + título, para telas de detalhe e forms.
///
/// A navegação inferior NÃO entra aqui: use [AppBottomNav] no body das
/// telas de primeiro nível (Início e Perfil), como no protótipo.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.title,
    this.showBrand = false,
    this.brandSubtitle,
    this.actions = const [],
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.showBack = false,
    this.padded = true,
    this.brandAsset,
  });

  final Widget body;

  /// Título da barra interna (ignorado quando [showBrand] é true).
  final String? title;

  /// Mostra a barra de marca (logo + "MeuPet+") em vez da barra de título.
  final bool showBrand;

  /// Subtítulo abaixo do nome na barra de marca (ex.: "Olá, Ana").
  final String? brandSubtitle;

  /// Asset da logo (ex.: 'assets/logo.png'). Se nulo, mostra um ícone.
  final String? brandAsset;

  final List<Widget> actions;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  /// Força a barra de voltar mesmo sem rota anterior.
  final bool showBack;

  /// Aplica o padding lateral padrão ([AppSpacing.screen]) no body.
  final bool padded;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context, scheme, canPop),
      body: padded
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screen,
                ),
                child: body,
              ),
            )
          : SafeArea(child: body),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  PreferredSizeWidget? _buildAppBar(
    BuildContext context,
    ColorScheme scheme,
    bool canPop,
  ) {
    if (showBrand) {
      return AppBar(
        titleSpacing: AppSpacing.screen,
        title: Row(
          children: [
            _BrandLogo(asset: brandAsset),
            const Gap.sm(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('MeuPet+', style: AppTypography.titleSmall),
                  if (brandSubtitle != null)
                    Text(
                      brandSubtitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: scheme.onPrimary.withValues(alpha: .75),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: actions,
      );
    }

    final hasBack = showBack || canPop;
    if (title == null && !hasBack && actions.isEmpty) return null;

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          if (hasBack) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Voltar',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
          Expanded(
            child: Text(
              title ?? '',
              style: AppTypography.titleMedium.copyWith(
                color: scheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({this.asset});

  final String? asset;

  @override
  Widget build(BuildContext context) {
    if (asset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(asset!, width: 36, height: 36, fit: BoxFit.cover),
      );
    }
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.pets, color: Color(0xFF102D59), size: 22),
    );
  }
}
