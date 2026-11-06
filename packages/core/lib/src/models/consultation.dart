import 'json.dart';

/// A vet visit of a pet.
class Consultation {
  const Consultation({
    required this.id,
    required this.petId,
    required this.date,
    required this.veterinarian,
    required this.reason,
    this.notes,
  });

  factory Consultation.fromJson(Json json) => Consultation(
    id: json.readString('id'),
    petId: json.readString('petId'),
    date: json.readApiDate('date'),
    veterinarian: json.readString('veterinarian'),
    reason: json.readString('reason'),
    notes: json.readOptionalString('notes'),
  );

  final String id;
  final String petId;
  final DateTime date;
  final String veterinarian;
  final String reason;
  final String? notes;

  /// Fields accepted by `POST /pets/:id/consultations`.
  Json toCreateJson() => {
    'date': _apiDate(date),
    'veterinarian': veterinarian,
    'reason': reason,
    'notes': notes,
  };

  Json toJson() => {
    'id': id,
    'petId': petId,
    'date': _apiDate(date),
    'veterinarian': veterinarian,
    'reason': reason,
    'notes': notes,
  };

  static String _apiDate(DateTime date) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }
}
