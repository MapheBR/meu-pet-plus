/// Dados em memória do mock. Reiniciar o server volta ao seed inicial —
/// suficiente para a disciplina (o contrato é o que importa).
library;

/// Store em memória do MeuPet+ mock.
///
/// Tudo é JSON-like (`Map<String, Object?>`) porque o Shelf serializa
/// direto — os mesmos formatos documentados no API.md.
class MockStore {
  MockStore() {
    _seed();
  }

  static const userId = 'usr_001';
  static const userEmail = 'ana@exemplo.com';
  static const userPassword = '123456';
  static const token = 'mock_token_meupet_demo';

  late final Map<String, Object?> user;
  final List<Map<String, Object?>> pets = [];
  final List<Map<String, Object?>> vaccines = [];
  final List<Map<String, Object?>> consultations = [];
  final List<Map<String, Object?>> weights = [];

  // Sequências começam depois do maior id do seed (pet_002, vac_004,
  // con_003, wei_005) para não duplicar ids.
  int _petSeq = 2;
  int _vaccineSeq = 4;
  int _consultationSeq = 3;
  int _weightSeq = 5;

  String nextPetId() => 'pet_${(++_petSeq).toString().padLeft(3, '0')}';
  String nextVaccineId() =>
      'vac_${(++_vaccineSeq).toString().padLeft(3, '0')}';
  String nextConsultationId() =>
      'con_${(++_consultationSeq).toString().padLeft(3, '0')}';
  String nextWeightId() => 'wei_${(++_weightSeq).toString().padLeft(3, '0')}';

  Map<String, Object?>? petById(String id) {
    for (final pet in pets) {
      if (pet['id'] == id) return pet;
    }
    return null;
  }

  List<Map<String, Object?>> vaccinesOf(String petId) => [
    for (final v in vaccines)
      if (v['petId'] == petId) v,
  ]..sort(
    (a, b) => '${a['nextDueDate']}'.compareTo('${b['nextDueDate']}'),
  );

  List<Map<String, Object?>> consultationsOf(String petId) => [
    for (final c in consultations)
      if (c['petId'] == petId) c,
  ]..sort((a, b) => '${b['date']}'.compareTo('${a['date']}'));

  List<Map<String, Object?>> weightsOf(String petId) => [
    for (final w in weights)
      if (w['petId'] == petId) w,
  ]..sort((a, b) => '${a['date']}'.compareTo('${b['date']}'));

  /// Bloco `summary` do GET /pets e de /pets/:id/summary.
  Map<String, Object?> summaryOf(String petId) {
    final petVaccines = vaccinesOf(petId);
    final petConsultations = consultationsOf(petId);
    final petWeights = weightsOf(petId);

    Map<String, Object?>? nextVaccine;
    if (petVaccines.isNotEmpty) {
      // vaccinesOf já vem ordenada por nextDueDate asc → a primeira é a mais urgente.
      final v = petVaccines.first;
      nextVaccine = {
        'id': v['id'],
        'name': v['name'],
        'applicationDate': v['applicationDate'],
        'nextDueDate': v['nextDueDate'],
      };
    }

    Map<String, Object?>? lastConsultation;
    if (petConsultations.isNotEmpty) {
      final c = petConsultations.first; // já vem da mais recente
      lastConsultation = {
        'id': c['id'],
        'date': c['date'],
        'veterinarian': c['veterinarian'],
        'reason': c['reason'],
      };
    }

    Map<String, Object?>? weight;
    if (petWeights.isNotEmpty) {
      final first = petWeights.first;
      final last = petWeights.last;
      final count = petWeights.length;
      weight = {
        'currentKg': last['weightKg'],
        'variationKg': count >= 2
            ? (last['weightKg'] as num) - (first['weightKg'] as num)
            : null,
        'firstDate': first['date'],
        'lastDate': last['date'],
      };
    }

    return {
      'nextVaccine': nextVaccine,
      'lastConsultation': lastConsultation,
      'weight': weight,
    };
  }

  // ── Seed ────────────────────────────────────────────────────────────────

  static String _apiDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  static DateTime _daysFromNow(int days) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + days);
  }

  void _seed() {
    user = {
      'id': userId,
      'name': 'Ana Souza',
      'email': userEmail,
      'createdAt': '2026-01-10T00:00:00.000Z',
    };

    // Thor — cachorro com os três estados de vacina (como no protótipo):
    // V8 vencida, V10 vence em ~15 dias, Antirrábica em dia.
    pets.add({
      'id': 'pet_001',
      'name': 'Thor',
      'species': 'dog',
      'breed': 'Golden Retriever',
      'birthDate': _apiDate(_daysFromNow(-730)),
      'tutorId': userId,
    });
    vaccines.addAll([
      {
        'id': 'vac_001',
        'petId': 'pet_001',
        'name': 'V8',
        'applicationDate': _apiDate(_daysFromNow(-66)),
        'nextDueDate': _apiDate(_daysFromNow(-6)), // vencida
      },
      {
        'id': 'vac_002',
        'petId': 'pet_001',
        'name': 'V10',
        'applicationDate': _apiDate(_daysFromNow(-140)),
        'nextDueDate': _apiDate(_daysFromNow(15)), // vence em breve
      },
      {
        'id': 'vac_003',
        'petId': 'pet_001',
        'name': 'Antirrábica',
        'applicationDate': _apiDate(_daysFromNow(-100)),
        'nextDueDate': _apiDate(_daysFromNow(200)), // em dia
      },
    ]);
    consultations.addAll([
      {
        'id': 'con_001',
        'petId': 'pet_001',
        'date': _apiDate(_daysFromNow(-45)),
        'veterinarian': 'Dra. Camila Reis',
        'reason': 'Check-up anual',
        'notes': 'Animal saudável, peso estável.',
      },
      {
        'id': 'con_002',
        'petId': 'pet_001',
        'date': _apiDate(_daysFromNow(-170)),
        'veterinarian': 'Dr. Paulo Mendes',
        'reason': 'Vacinação de rotina',
        'notes': null,
      },
    ]);
    weights.addAll([
      {
        'id': 'wei_001',
        'petId': 'pet_001',
        'date': _apiDate(_daysFromNow(-140)),
        'weightKg': 12.0,
      },
      {
        'id': 'wei_002',
        'petId': 'pet_001',
        'date': _apiDate(_daysFromNow(-80)),
        'weightKg': 12.3,
      },
      {
        'id': 'wei_003',
        'petId': 'pet_001',
        'date': _apiDate(_daysFromNow(-3)),
        'weightKg': 12.5,
      },
    ]);

    // Mel — gata com menos registros (variedade na Home).
    pets.add({
      'id': 'pet_002',
      'name': 'Mel',
      'species': 'cat',
      'breed': 'Siamês',
      'birthDate': _apiDate(_daysFromNow(-400)),
      'tutorId': userId,
    });
    vaccines.add({
      'id': 'vac_004',
      'petId': 'pet_002',
      'name': 'V4',
      'applicationDate': _apiDate(_daysFromNow(-30)),
      'nextDueDate': _apiDate(_daysFromNow(335)), // em dia
    });
    consultations.add({
      'id': 'con_003',
      'petId': 'pet_002',
      'date': _apiDate(_daysFromNow(-60)),
      'veterinarian': 'Dra. Camila Reis',
      'reason': 'Consulta de rotina',
      'notes': null,
    });
    weights.addAll([
      {
        'id': 'wei_004',
        'petId': 'pet_002',
        'date': _apiDate(_daysFromNow(-60)),
        'weightKg': 4.1,
      },
      {
        'id': 'wei_005',
        'petId': 'pet_002',
        'date': _apiDate(_daysFromNow(-5)),
        'weightKg': 4.2,
      },
    ]);
  }
}
