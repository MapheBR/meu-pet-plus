import 'package:meupet_core/meupet_core.dart';

import '../../app/app_dependencies.dart';

/// Backend of the pet detail scene.
abstract interface class ServerPetDetail {
  /// Pet data: `GET /pets/:id`.
  Future<Result<Pet>> fetchPet(String petId);

  /// Resumo tab data: `GET /pets/:id/summary`.
  Future<Result<PetSummary>> fetchSummary(String petId);

  /// Vacinas tab: `GET /pets/:id/vaccines`.
  Future<Result<List<Vaccine>>> fetchVaccines(String petId);

  /// Consultas tab: `GET /pets/:id/consultations`.
  Future<Result<List<Consultation>>> fetchConsultations(String petId);

  /// Peso tab: `GET /pets/:id/weights`.
  Future<Result<List<WeightRecord>>> fetchWeights(String petId);

  /// Clears the saved session (used when the token is no longer valid).
  Future<void> clearSession();
}

/// Real [ServerPetDetail], using the Core repositories.
class PetDetailServer implements ServerPetDetail {
  PetDetailServer({
    PetRepository? pets,
    VaccineRepository? vaccines,
    ConsultationRepository? consultations,
    WeightRepository? weights,
    AuthRepository? auth,
  }) : _pets = pets ?? AppDependencies.pets,
       _vaccines = vaccines ?? AppDependencies.vaccines,
       _consultations = consultations ?? AppDependencies.consultations,
       _weights = weights ?? AppDependencies.weights,
       _auth = auth ?? AppDependencies.auth;

  final PetRepository _pets;
  final VaccineRepository _vaccines;
  final ConsultationRepository _consultations;
  final WeightRepository _weights;
  final AuthRepository _auth;

  @override
  Future<Result<Pet>> fetchPet(String petId) => _pets.getById(petId);

  @override
  Future<Result<PetSummary>> fetchSummary(String petId) =>
      _pets.summary(petId);

  @override
  Future<Result<List<Vaccine>>> fetchVaccines(String petId) =>
      _vaccines.listByPet(petId);

  @override
  Future<Result<List<Consultation>>> fetchConsultations(String petId) =>
      _consultations.listByPet(petId);

  @override
  Future<Result<List<WeightRecord>>> fetchWeights(String petId) =>
      _weights.listByPet(petId);

  @override
  Future<void> clearSession() async {
    await _auth.logout();
  }
}
