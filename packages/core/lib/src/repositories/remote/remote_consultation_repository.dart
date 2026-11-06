import '../../api/api_client.dart';
import '../../format/parse_list.dart';
import '../../models/json.dart';
import '../../models/consultation.dart';
import '../../result/result.dart';
import '../consultation_repository.dart';

/// Consultations against the API.
class RemoteConsultationRepository implements ConsultationRepository {
  RemoteConsultationRepository({required this._client});

  final ApiClient _client;

  @override
  Future<Result<List<Consultation>>> listByPet(String petId) async {
    final result = await _client.get('/pets/$petId/consultations');
    return result.map((json) => parseList(json, Consultation.fromJson));
  }

  @override
  Future<Result<Consultation>> create(
    String petId,
    Consultation consultation,
  ) async {
    final result = await _client.post(
      '/pets/$petId/consultations',
      body: consultation.toCreateJson(),
    );
    return result.map((json) => Consultation.fromJson(asJson(json)));
  }
}
