import 'json.dart';

/// One weight measurement of a pet, in kilograms.
class WeightRecord {
  const WeightRecord({
    required this.id,
    required this.petId,
    required this.date,
    required this.weightKg,
  });

  factory WeightRecord.fromJson(Json json) => WeightRecord(
    id: json.readString('id'),
    petId: json.readString('petId'),
    date: json.readApiDate('date'),
    weightKg: json.readDouble('weightKg'),
  );

  final String id;
  final String petId;
  final DateTime date;
  final double weightKg;

  /// Fields accepted by `POST /pets/:id/weights`.
  Json toCreateJson() => {
    'date': _apiDate(date),
    'weightKg': weightKg,
  };

  Json toJson() => {
    'id': id,
    'petId': petId,
    'date': _apiDate(date),
    'weightKg': weightKg,
  };

  static String _apiDate(DateTime date) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }
}
