import 'package:meupet_core/meupet_core.dart';

import '../../app/app_dependencies.dart';

/// Backend of the home scene.
abstract interface class ServerHome {
  /// Pets of the tutor with their health summary: `GET /pets`.
  Future<Result<List<Pet>>> fetchPets();

  /// First name of the signed-in user, from the stored session (no request).
  String? get userFirstName;

  /// Clears the saved session (used when the token is no longer valid).
  Future<void> clearSession();
}

/// Real [ServerHome], using the Core repositories.
class HomeServer implements ServerHome {
  HomeServer({PetRepository? pets, AuthRepository? auth})
    : _pets = pets ?? AppDependencies.pets,
      _auth = auth ?? AppDependencies.auth;

  final PetRepository _pets;
  final AuthRepository _auth;

  @override
  Future<Result<List<Pet>>> fetchPets() => _pets.list();

  @override
  String? get userFirstName => _auth.currentSession?.user.firstName;

  @override
  Future<void> clearSession() async {
    await _auth.logout();
  }
}
