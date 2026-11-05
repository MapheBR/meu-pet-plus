import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// Um ponto do gráfico de peso.
class WeightPoint {
  const WeightPoint({required this.date, required this.kg});

  final DateTime date;
  final double kg;
}

/// Gráfico de linha do peso do pet: linha azul-marinho, pontos laranja,
/// eixo Y em kg e eixo X com as datas — igual ao protótipo.
class WeightChart extends StatelessWidget {
  const WeightChart({required this.points, super.key, this.height = 140});

  final List<WeightPoint> points;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('Registre pelo menos 2 pesos')),
      );
    }
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline),
      ),
      child: CustomPaint(
        painter: _WeightChartPainter(
          points: points,
          lineColor: AppColors.navy,
          dotColor: AppColors.orange,
          gridColor: scheme.outline,
          labelColor: scheme.onSurfaceVariant,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _WeightChartPainter extends CustomPainter {
  _WeightChartPainter({
    required this.points,
    required this.lineColor,
    required this.dotColor,
    required this.gridColor,
    required this.labelColor,
  });

  final List<WeightPoint> points;
  final Color lineColor;
  final Color dotColor;
  final Color gridColor;
  final Color labelColor;

  // Área útil do desenho (deixa margem para os rótulos).
  static const double left = 30;
  static const double right = 8;
  static const double top = 10;
  static const double bottom = 26;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final minKg = points.map((p) => p.kg).reduce((a, b) => a < b ? a : b);
    final maxKg = points.map((p) => p.kg).reduce((a, b) => a > b ? a : b);
    // Margem de 0,5 kg em cima/embaixo para a linha não colar na borda.
    final lo = minKg - 0.5;
    final hi = maxKg + 0.5;

    final plotW = size.width - left - right;
    final plotH = size.height - top - bottom;
    final first = points.first.date;
    final last = points.last.date;
    final span = last.difference(first).inDays == 0
        ? 1
        : last.difference(first).inDays.toDouble();

    Offset pos(WeightPoint p) {
      final x = left + (p.date.difference(first).inDays / span) * plotW;
      final y = top + (1 - (p.kg - lo) / (hi - lo)) * plotH;
      return Offset(x, y);
    }

    // Gridlines + rótulos do eixo Y (kg).
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    final labelStyle = AppTypography.bodySmall.copyWith(color: labelColor);
    for (var i = 0; i <= 3; i++) {
      final kg = lo + (hi - lo) * i / 3;
      final y = top + plotH * (1 - i / 3);
      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );
      _drawText(
        canvas,
        kg.toStringAsFixed(1).replaceAll('.', ','),
        Offset(2, y - 6),
        labelStyle,
        TextAlign.left,
      );
    }

    // Linha.
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()..moveTo(pos(points.first).dx, pos(points.first).dy);
    for (final p in points.skip(1)) {
      path.lineTo(pos(p).dx, pos(p).dy);
    }
    canvas.drawPath(path, linePaint);

    // Pontos laranja com borda branca.
    final dotPaint = Paint()..color = dotColor;
    final dotBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final p in points) {
      canvas.drawCircle(pos(p), 5, dotPaint);
      canvas.drawCircle(pos(p), 5, dotBorder);
    }

    // Rótulos do eixo X (datas, formato dd/MM).
    final dateStyle = AppTypography.bodySmall.copyWith(color: labelColor);
    final step = points.length <= 4
        ? 1
        : (points.length / 4).ceil();
    for (var i = 0; i < points.length; i += step) {
      final p = points[i];
      final label =
          '${p.date.day.toString().padLeft(2, '0')}/${p.date.month.toString().padLeft(2, '0')}';
      _drawText(
        canvas,
        label,
        Offset(pos(p).dx - 14, size.height - bottom + 8),
        dateStyle,
        TextAlign.left,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style,
    TextAlign align,
  ) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_WeightChartPainter old) => old.points != points;
}
