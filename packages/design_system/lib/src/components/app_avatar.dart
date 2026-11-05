import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Avatar circular do pet/usuário: fundo azul claro, ícone [icon]
/// (ex.: Icons.pets) em azul-marinho, borda fina.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.icon = Icons.pets,
    this.size = 48,
    this.imagePath,
  });

  final IconData icon;
  final double size;

  /// Caminho de uma imagem local; se nulo, mostra o ícone.
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: imagePath == null ? scheme.primaryContainer : scheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.navy.withValues(alpha: .25)),
      ),
      clipBehavior: Clip.antiAlias,
      child: imagePath != null
          ? Image.asset(imagePath!, fit: BoxFit.cover)
          : Icon(icon, size: size * .5, color: scheme.primary),
    );
  }
}
