/// Date helpers for the API contract (`YYYY-MM-DD`) and the screens
/// (`dd/MM/yyyy`). Pure Dart, no intl dependency.
library;

/// `2026-11-20` — the format every date field uses in requests/responses.
String formatApiDate(DateTime date) {
  final d = date.toLocal();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${d.year.toString().padLeft(4, '0')}-${two(d.month)}-${two(d.day)}';
}

/// `20/11/2026` — how dates appear on the screens.
String formatDateBr(DateTime date) {
  final d = date.toLocal();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(d.day)}/${two(d.month)}/${d.year}';
}

/// Compares two dates ignoring the time part.
int compareApiDates(DateTime a, DateTime b) {
  final da = DateTime(a.year, a.month, a.day);
  final db = DateTime(b.year, b.month, b.day);
  return da.compareTo(db);
}

/// Whole days from [from] to [to] (positive when [to] is in the future).
int daysBetween(DateTime from, DateTime to) {
  final f = DateTime(from.year, from.month, from.day);
  final t = DateTime(to.year, to.month, to.day);
  return t.difference(f).inDays;
}

/// "2 anos", "8 meses", "3 dias" — used for the pet's age on cards.
String formatAge(DateTime birthDate, {DateTime? now}) {
  final n = now ?? DateTime.now();
  var months =
      (n.year - birthDate.year) * 12 + n.month - birthDate.month;
  if (n.day < birthDate.day) months--;
  if (months < 1) {
    final days = daysBetween(birthDate, n);
    if (days < 30) return days <= 1 ? 'recém-nascido' : '$days dias';
    return '1 mês';
  }
  if (months < 12) return months == 1 ? '1 mês' : '$months meses';
  final years = months ~/ 12;
  final rest = months % 12;
  if (rest == 0) return years == 1 ? '1 ano' : '$years anos';
  return '${years == 1 ? '1 ano' : '$years anos'} e '
      '${rest == 1 ? '1 mês' : '$rest meses'}';
}

/// "+0,5 kg em 4 meses" style summary for the weight tab.
/// Returns null when there is not enough data.
String? formatWeightVariation(
  double firstKg,
  double lastKg,
  DateTime firstDate,
  DateTime lastDate,
) {
  final diff = lastKg - firstKg;
  final sign = diff >= 0 ? '+' : '−';
  final kg = diff.abs().toStringAsFixed(1).replaceAll('.', ',');
  final months = daysBetween(firstDate, lastDate) ~/ 30;
  final period = switch (months) {
    0 => 'no mesmo mês',
    1 => 'em 1 mês',
    _ when months < 12 => 'em $months meses',
    _ => 'em ${(months / 12).floor()} anos',
  };
  return '$sign$kg kg $period';
}

/// "há 3 meses", "há 15 dias", "hoje" — para datas no passado
/// (ex.: "Última consulta — há 3 meses").
String formatRelativePast(DateTime date, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final days = daysBetween(date, n);
  if (days <= 0) return 'hoje';
  if (days < 30) return days == 1 ? 'há 1 dia' : 'há $days dias';
  final months = days ~/ 30;
  if (months < 12) return months == 1 ? 'há 1 mês' : 'há $months meses';
  final years = months ~/ 12;
  return years == 1 ? 'há 1 ano' : 'há $years anos';
}

const _monthNames = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

/// "março" — nome do mês em minúsculas (ex.: "+1,2 kg desde março").
String monthNamePt(int month) => _monthNames[month - 1];
