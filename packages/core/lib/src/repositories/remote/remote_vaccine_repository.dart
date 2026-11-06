import '../../api/api_client.dart';
import '../../format/parse_list.dart';
import '../../models/json.dart';
import '../../models/vaccine.dart';
import '../../result/result.dart';
import '../vaccine_repository.dart';

/// Vaccines against the API.
class RemoteVaccineRepository implements VaccineRepository {
  RemoteVaccineRepository({required this._client});

  final ApiClient _client;

  @override
  Future<Result<List<Vaccine>>> listByPet(String petId) async {
    final result = await _client.get('/pets/$petId/vaccines');
    return result.map((json) => parseList(json, Vaccine.fromJson));
  }

  @override
  Future<Result<Vaccine>> create(String petId, Vaccine vaccine) async {
    final result = await _client.post(
      '/pets/$petId/vaccines',
      body: vaccine.toCreateJson(),
    );
    return result.map((json) => Vaccine.fromJson(asJson(json)));
  }
}
