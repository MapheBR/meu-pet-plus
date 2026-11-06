import 'package:meupet_core/meupet_core.dart';

import '../../app/app_dependencies.dart';

/// Backend of the record form scene (vacina, consulta ou peso).
abstract interface class ServerRecordForm {
  Future<Result<void>> saveVaccine(
    String petId, {
    required String name,
    required DateTime applicationDate,
    required DateTime nextDueDate,
    String? veterinarian,
    String? notes,
  });

  Future<Result<void>> saveConsultation(
    String petId, {
    required DateTime date,
    required String veterinarian,
    required String reason,
    String? notes,
  });

  Future<Result<void>> saveWeight(
    String petId, {
    required DateTime date,
    required double weightKg,
  });
}

/// Real [ServerRecordForm], using the Core repositories.
class RecordFormServer implements ServerRecordForm {
  RecordFormServer({
    VaccineRepository? vaccines,
    ConsultationRepository? consultations,
    WeightRepository? weights,
  }) : _vaccines = vaccines ?? AppDependencies.vaccines,
       _consultations = consultations ?? AppDependencies.consultations,
       _weights = weights ?? AppDependencies.weights;

  final VaccineRepository _vaccines;
  final ConsultationRepository _consultations;
  final WeightRepository _weights;

  @override
  Future<Result<void>> saveVaccine(
    String petId, {
    required String name,
    required DateTime applicationDate,
    required DateTime nextDueDate,
    String? veterinarian,
    String? notes,
  }) async {
    String? clean(String? v) =>
        v == null || v.trim().isEmpty ? null : v.trim();
    final result = await _vaccines.create(
      petId,
      Vaccine(
        id: '',
        petId: petId,
        name: name.trim(),
        applicationDate: applicationDate,
        nextDueDate: nextDueDate,
        veterinarian: clean(veterinarian),
        notes: clean(notes),
      ),
    );
    return result.map((_) {});
  }

  @override
  Future<Result<void>> saveConsultation(
    String petId, {
    required DateTime date,
    required String veterinarian,
    required String reason,
    String? notes,
  }) async {
    final result = await _consultations.create(
      petId,
      Consultation(
        id: '',
        petId: petId,
        date: date,
        veterinarian: veterinarian.trim(),
        reason: reason.trim(),
        notes: notes?.trim().isEmpty ?? true ? null : notes!.trim(),
      ),
    );
    return result.map((_) {});
  }

  @override
  Future<Result<void>> saveWeight(
    String petId, {
    required DateTime date,
    required double weightKg,
  }) async {
    final result = await _weights.create(
      petId,
      WeightRecord(id: '', petId: petId, date: date, weightKg: weightKg),
    );
    return result.map((_) {});
  }
}
