import 'package:meupet_core/meupet_core.dart';
import 'package:flutter/foundation.dart';

import 'file_session_storage.dart';

/// Objetos compartilhados por todas as cenas.
///
/// Existe uma única instância de cada um: o [ApiClient] guarda o token, então
/// Login e Home precisam usar o mesmo cliente.
abstract final class AppDependencies {
  /// Emulador Android enxerga o PC em 10.0.2.2; desktop/simulador/web usam
  /// localhost (o server mock roda em `dart run bin/server.dart`).
  static final String baseUrl =
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:8080'
      : 'http://localhost:8080';

  static final ApiClient apiClient = ApiClient(baseUrl: baseUrl);

  static final SessionStorage sessionStorage =
      kIsWeb ? InMemorySessionStorage() : FileSessionStorage();

  static final AuthRepository auth = RemoteAuthRepository(
    client: apiClient,
    storage: sessionStorage,
  );

  static final UserRepository users = RemoteUserRepository(client: apiClient);

  static final PetRepository pets = RemotePetRepository(client: apiClient);

  static final VaccineRepository vaccines = RemoteVaccineRepository(
    client: apiClient,
  );

  static final ConsultationRepository consultations =
      RemoteConsultationRepository(client: apiClient);

  static final WeightRepository weights = RemoteWeightRepository(
    client: apiClient,
  );
}
