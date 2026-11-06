import 'server_splash.dart';
import 'splash_coordinator.dart';

/// Decides the first screen: Home when a session is saved, Login otherwise.
class SplashViewModel {
  SplashViewModel({required this._serverSplash, required this._coordinator});

  final ServerSplash _serverSplash;
  final SplashCoordinator _coordinator;

  Future<void> start() async {
    final result = await _serverSplash.restoreSession();
    final session = result.valueOrNull;
    if (session != null) {
      _coordinator.goToHome();
    } else {
      _coordinator.goToLogin();
    }
  }
}
