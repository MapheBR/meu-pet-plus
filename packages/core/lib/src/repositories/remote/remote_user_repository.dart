import '../../api/api_client.dart';
import '../../models/json.dart';
import '../../models/user.dart';
import '../../result/result.dart';
import '../user_repository.dart';

/// Profile against the API.
class RemoteUserRepository implements UserRepository {
  RemoteUserRepository({required this._client});

  final ApiClient _client;

  @override
  Future<Result<User>> getProfile() async {
    final result = await _client.get('/me');
    return result.map((json) => User.fromJson(asJson(json)));
  }
}
