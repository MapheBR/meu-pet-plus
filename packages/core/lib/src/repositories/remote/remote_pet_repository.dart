import '../../api/api_client.dart';
import '../../format/parse_list.dart';
import '../../models/json.dart';
import '../../models/pet.dart';
import '../../result/result.dart';
import '../pet_repository.dart';

/// Pets against the API.
class RemotePetRepository implements PetRepository {
  RemotePetRepository({required this._client});

  final ApiClient _client;

  @override
  Future<Result<List<Pet>>> list() async {
    final result = await _client.get('/pets');
    return result.map((json) => parseList(json, Pet.fromJson));
  }

  @override
  Future<Result<Pet>> getById(String id) async {
    final result = await _client.get('/pets/$id');
    return result.map((json) => Pet.fromJson(asJson(json)));
  }

  @override
  Future<Result<PetSummary>> summary(String petId) async {
    final result = await _client.get('/pets/$petId/summary');
    return result.map((json) => PetSummary.fromJson(asJson(json)));
  }

  @override
  Future<Result<Pet>> create(Pet pet) async {
    final result = await _client.post('/pets', body: pet.toCreateJson());
    return result.map((json) => Pet.fromJson(asJson(json)));
  }
}
