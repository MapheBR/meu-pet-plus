import '../models/consultation.dart';
import '../result/result.dart';

/// Consultations of a pet.
abstract interface class ConsultationRepository {
  /// `GET /pets/:id/consultations` — sorted by date, most recent first.
  Future<Result<List<Consultation>>> listByPet(String petId);

  /// `POST /pets/:id/consultations`.
  Future<Result<Consultation>> create(String petId, Consultation consultation);
}
