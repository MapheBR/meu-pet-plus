import 'json.dart';
import 'species.dart';

/// A pet of the signed-in tutor.
class Pet {
  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.birthDate,
    required this.tutorId,
    this.breed,
    this.summary,
  });

  factory Pet.fromJson(Json json) => Pet(
    id: json.readString('id'),
    name: json.readString('name'),
    species: PetSpecies.fromJson(json, 'species'),
    breed: json.readOptionalString('breed'),
    birthDate: json.readApiDate('birthDate'),
    tutorId: json.readString('tutorId'),
    summary: json['summary'] == null
        ? null
        : PetSummary.fromJson(asJson(json['summary'])),
  );

  final String id;
  final String name;
  final PetSpecies species;
  final String? breed;
  final DateTime birthDate;
  final String tutorId;

  /// Health summary — present only in `GET /pets` items (Home cards),
  /// absent in `GET /pets/:id`.
  final PetSummary? summary;

  /// Fields accepted by `POST /pets`.
  Json toCreateJson() => {
    'name': name,
    'species': species.apiValue,
    'breed': breed,
    'birthDate': _apiDate(birthDate),
  };

  Json toJson() => {
    'id': id,
    'name': name,
    'species': species.apiValue,
    'breed': breed,
    'birthDate': _apiDate(birthDate),
    'tutorId': tutorId,
    'summary': summary?.toJson(),
  };

  static String _apiDate(DateTime date) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)}';
  }
}

/// Aggregated health data of a pet, from `GET /pets/:id/summary`.
///
/// The API returns raw data; the app calculates texts and the vaccine
/// status chip (rule documented in API.md).
class PetSummary {
  const PetSummary({
    this.nextVaccine,
    this.lastConsultation,
    this.weight,
  });

  /// The vaccine with the nearest `nextDueDate`, or null when the pet has
  /// no vaccines at all.
  final NextVaccine? nextVaccine;

  /// The most recent consultation, or null.
  final LastConsultation? lastConsultation;

  /// Weight evolution, or null when there are no records.
  final WeightSummary? weight;

  factory PetSummary.fromJson(Json json) => PetSummary(
    nextVaccine: json['nextVaccine'] == null
        ? null
        : NextVaccine.fromJson(asJson(json['nextVaccine'])),
    lastConsultation: json['lastConsultation'] == null
        ? null
        : LastConsultation.fromJson(asJson(json['lastConsultation'])),
    weight: json['weight'] == null
        ? null
        : WeightSummary.fromJson(asJson(json['weight'])),
  );

  Json toJson() => {
    'nextVaccine': nextVaccine?.toJson(),
    'lastConsultation': lastConsultation?.toJson(),
    'weight': weight?.toJson(),
  };

  static const empty = PetSummary();
}

/// The most urgent vaccine inside [PetSummary].
class NextVaccine {
  const NextVaccine({
    required this.id,
    required this.name,
    required this.applicationDate,
    required this.nextDueDate,
  });

  factory NextVaccine.fromJson(Json json) => NextVaccine(
    id: json.readString('id'),
    name: json.readString('name'),
    applicationDate: json.readApiDate('applicationDate'),
    nextDueDate: json.readApiDate('nextDueDate'),
  );

  final String id;
  final String name;
  final DateTime applicationDate;
  final DateTime nextDueDate;

  Json toJson() => {
    'id': id,
    'name': name,
    'applicationDate': _apiDate(applicationDate),
    'nextDueDate': _apiDate(nextDueDate),
  };
}

/// The most recent consultation inside [PetSummary].
class LastConsultation {
  const LastConsultation({
    required this.id,
    required this.date,
    required this.veterinarian,
    required this.reason,
  });

  factory LastConsultation.fromJson(Json json) => LastConsultation(
    id: json.readString('id'),
    date: json.readApiDate('date'),
    veterinarian: json.readString('veterinarian'),
    reason: json.readString('reason'),
  );

  final String id;
  final DateTime date;
  final String veterinarian;
  final String reason;

  Json toJson() => {
    'id': id,
    'date': _apiDate(date),
    'veterinarian': veterinarian,
    'reason': reason,
  };
}

/// Weight evolution inside [PetSummary].
class WeightSummary {
  const WeightSummary({
    required this.currentKg,
    this.variationKg,
    this.firstDate,
    this.lastDate,
  });

  factory WeightSummary.fromJson(Json json) => WeightSummary(
    currentKg: json.readDouble('currentKg'),
    variationKg: switch (json['variationKg']) {
      num v => v.toDouble(),
      _ => null,
    },
    firstDate: switch (json['firstDate']) {
      String v => DateTime.tryParse(v),
      _ => null,
    },
    lastDate: switch (json['lastDate']) {
      String v => DateTime.tryParse(v),
      _ => null,
    },
  );

  /// Latest weight, in kg.
  final double currentKg;

  /// last − first, or null with fewer than 2 records.
  final double? variationKg;
  final DateTime? firstDate;
  final DateTime? lastDate;

  Json toJson() => {
    'currentKg': currentKg,
    'variationKg': variationKg,
    'firstDate': firstDate == null ? null : _apiDate(firstDate!),
    'lastDate': lastDate == null ? null : _apiDate(lastDate!),
  };
}

String _apiDate(DateTime date) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${date.year}-${two(date.month)}-${two(date.day)}';
}
