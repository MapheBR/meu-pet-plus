import 'package:meupet_core/meupet_core.dart';

import '../../app/app_dependencies.dart';

/// Backend of the pet form scene.
abstract interface class ServerPetForm {
  /// `POST /pets`.
  Future<Result<Pet>> createPet({
    required String name,
    required PetSpecies species,
    String? breed,
    required DateTime birthDate,
  });
}

/// Real [ServerPetForm], using the Core's [PetRepository].
class PetFormServer implements ServerPetForm {
  PetFormServer({PetRepository? pets}) : _pets = pets ?? AppDependencies.pets;

  final PetRepository _pets;

  @override
  Future<Result<Pet>> createPet({
    required String name,
    required PetSpecies species,
    String? breed,
    required DateTime birthDate,
  }) {
    // id e tutorId são ignorados pelo POST — o servidor atribui.
    final pet = Pet(
      id: '',
      name: name.trim(),
      species: species,
      breed: breed?.trim().isEmpty ?? true ? null : breed!.trim(),
      birthDate: birthDate,
      tutorId: '',
    );
    return _pets.create(pet);
  }
}
