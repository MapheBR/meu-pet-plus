import '../models/session.dart';

/// Where the session survives between app launches.
///
/// The core package only knows the interface; the Flutter app provides an
/// implementation on top of a JSON file.
abstract interface class SessionStorage {
  Future<Session?> read();

  Future<void> write(Session session);

  Future<void> clear();
}
