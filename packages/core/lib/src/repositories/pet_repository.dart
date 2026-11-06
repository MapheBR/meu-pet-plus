import '../models/pet.dart';
import '../result/result.dart';

/// Pets of the signed-in tutor.
abstract interface class PetRepository {
  /// `GET /pets` — each item carries its [PetSummary] for the Home chip.
  Future<Result<List<Pet>>> list();

  /// `GET /pets/:id`.
  Future<Result<Pet>> getById(String id);

  /// `GET /pets/:id/summary` — aggregated data of the Resumo tab.
  Future<Result<PetSummary>> summary(String petId);

  /// `POST /pets`.
  Future<Result<Pet>> create(Pet pet);
}
