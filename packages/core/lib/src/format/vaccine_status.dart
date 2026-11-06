import 'date_x.dart';

/// Health state of a vaccine, calculated from `nextDueDate` vs. today.
///
/// Rule documented in API.md: the API sends raw dates and the app decides
/// the chip — "vencida" before today, "vence em breve" up to 30 days out,
/// "em dia" otherwise.
enum VaccineStatus { upToDate, dueSoon, overdue }

/// Days from today until [nextDueDate] (negative = already overdue).
int vaccineDaysUntil(DateTime nextDueDate, {DateTime? now}) =>
    daysBetween(now ?? DateTime.now(), nextDueDate);

VaccineStatus vaccineStatusOf(DateTime nextDueDate, {DateTime? now}) {
  final days = vaccineDaysUntil(nextDueDate, now: now);
  if (days < 0) return VaccineStatus.overdue;
  if (days <= 30) return VaccineStatus.dueSoon;
  return VaccineStatus.upToDate;
}
