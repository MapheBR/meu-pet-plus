import '../../api/api_client.dart';
import '../../format/parse_list.dart';
import '../../models/json.dart';
import '../../models/weight_record.dart';
import '../../result/result.dart';
import '../weight_repository.dart';

/// Weight records against the API.
class RemoteWeightRepository implements WeightRepository {
  RemoteWeightRepository({required this._client});

  final ApiClient _client;

  @override
  Future<Result<List<WeightRecord>>> listByPet(String petId) async {
    final result = await _client.get('/pets/$petId/weights');
    return result.map((json) => parseList(json, WeightRecord.fromJson));
  }

  @override
  Future<Result<WeightRecord>> create(String petId, WeightRecord record) async {
    final result = await _client.post(
      '/pets/$petId/weights',
      body: record.toCreateJson(),
    );
    return result.map((json) => WeightRecord.fromJson(asJson(json)));
  }
}
