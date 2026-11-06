import '../models/vaccine.dart';
import '../result/result.dart';

/// Vaccines of a pet.
abstract interface class VaccineRepository {
  /// `GET /pets/:id/vaccines` — sorted by `nextDueDate`, most urgent first.
  Future<Result<List<Vaccine>>> listByPet(String petId);

  /// `POST /pets/:id/vaccines`.
  Future<Result<Vaccine>> create(String petId, Vaccine vaccine);
}
