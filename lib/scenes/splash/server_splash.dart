import 'package:meupet_core/meupet_core.dart';

import '../../app/app_dependencies.dart';

/// Backend of the splash scene.
abstract interface class ServerSplash {
  /// Restores the saved session (token + user), if any.
  Future<Result<Session?>> restoreSession();
}

/// Real [ServerSplash], using the Core's [AuthRepository].
class SplashServer implements ServerSplash {
  SplashServer({AuthRepository? auth}) : _auth = auth ?? AppDependencies.auth;

  final AuthRepository _auth;

  @override
  Future<Result<Session?>> restoreSession() => _auth.restore();
}
