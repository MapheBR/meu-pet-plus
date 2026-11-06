import 'json.dart';

/// A vaccine applied to a pet, with the date of the next dose.
class Vaccine {
  const Vaccine({
    required this.id,
    required this.petId,
    required this.name,
    required this.applicationDate,
    required this.nextDueDate,
    this.veterinarian,
    this.notes,
  });

  factory Vaccine.fromJson(Json json) => Vaccine(
    id: json.readString('id'),
    petId: json.readString('petId'),
    name: json.readString('name'),
    applicationDate: json.readApiDate('applicationDate'),
    nextDueDate: json.readApiDate('nextDueDate'),
    veterinarian: json.readOptionalString('veterinarian'),
    notes: json.readOptionalString('notes'),
  );

  final String id;
  final String petId;
  final String name;
  final DateTime applicationDate;
  final DateTime nextDueDate;

  /// Optional fields of `POST /pets/:id/vaccines` (protótipo).
  final String? veterinarian;
  final String? notes;

  /// Fields accepted by `POST /pets/:id/vaccines`.
  Json toCreateJson() => {
    'name': name,
    'applicationDate': _apiDate(applicationDate),
    'nextDueDate': _apiDate(nextDueDate),
    'veterinarian': veterinarian,
    'notes': notes,
  };

  Json toJson() => {
    'id': id,
    'petId': petId,
    'name': name,
    'applicationDate': _apiDate(applicationDate),
    'nextDueDate': _apiDate(nextDueDate),
    'veterinarian': veterinarian,
    'notes': notes,
  };

  static String _apiDate(DateTime date) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }
}
