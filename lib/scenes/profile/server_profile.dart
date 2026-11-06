import 'package:meupet_core/meupet_core.dart';

import '../../app/app_dependencies.dart';

/// Backend of the profile scene.
abstract interface class ServerProfile {
  /// Signed-in user: `GET /me`.
  Future<Result<User>> fetchProfile();

  /// Ends the session on the server and clears the storage.
  Future<void> logout();
}

/// Real [ServerProfile], using the Core repositories.
class ProfileServer implements ServerProfile {
  ProfileServer({UserRepository? users, AuthRepository? auth})
    : _users = users ?? AppDependencies.users,
      _auth = auth ?? AppDependencies.auth;

  final UserRepository _users;
  final AuthRepository _auth;

  @override
  Future<Result<User>> fetchProfile() => _users.getProfile();

  @override
  Future<void> logout() async {
    await _auth.logout();
  }
}
