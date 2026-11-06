import '../models/weight_record.dart';
import '../result/result.dart';

/// Weight records of a pet.
abstract interface class WeightRepository {
  /// `GET /pets/:id/weights` — sorted by date, oldest first (chart order).
  Future<Result<List<WeightRecord>>> listByPet(String petId);

  /// `POST /pets/:id/weights`.
  Future<Result<WeightRecord>> create(String petId, WeightRecord record);
}
