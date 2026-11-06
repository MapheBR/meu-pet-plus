import '../models/user.dart';
import '../result/result.dart';

/// Profile of the signed-in user (`GET /me`).
abstract interface class UserRepository {
  Future<Result<User>> getProfile();
}
