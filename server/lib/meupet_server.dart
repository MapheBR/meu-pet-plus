/// API mock do MeuPet+ — implementa o contrato do `API.md`.
///
/// Dart puro (Shelf), dados em memória: reiniciar volta ao seed.
library;

import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'src/store.dart';

/// Monto o app Shelf completo (router + CORS + auth).
Handler buildApp() {
  final store = MockStore();
  final router = Router();

  // ── Health e auth ────────────────────────────────────────────────────────

  router.get('/health', (Request request) => json({'status': 'ok'}));

  router.post('/auth/login', (Request request) async {
    final body = await _body(request);
    if (body == null) return _badJson();

    final fields = <String, String>{};
    final email = '${body['email'] ?? ''}'.trim();
    final password = '${body['password'] ?? ''}';
    if (email.isEmpty) fields['email'] = 'Informe o e-mail.';
    if (password.isEmpty) fields['password'] = 'Informe a senha.';
    if (fields.isNotEmpty) return _validation(fields);

    if (email != MockStore.userEmail || password != MockStore.userPassword) {
      return _error(
        401,
        'invalid_credentials',
        'E-mail ou senha inválidos',
      );
    }

    return json({
      'token': MockStore.token,
      'user': store.user,
    });
  });

  router.post('/auth/logout', (Request request) async {
    return Response(204);
  });

  // ── Usuário ──────────────────────────────────────────────────────────────

  router.get('/me', (Request request) {
    return json(store.user);
  });

  // ── Pets ─────────────────────────────────────────────────────────────────

  router.get('/pets', (Request request) {
    return json([
      for (final pet in store.pets)
        {...pet, 'summary': store.summaryOf('${pet['id']}')},
    ]);
  });

  router.post('/pets', (Request request) async {
    final body = await _body(request);
    if (body == null) return _badJson();

    final fields = <String, String>{};
    final name = '${body['name'] ?? ''}'.trim();
    final species = '${body['species'] ?? ''}';
    final birthDate = '${body['birthDate'] ?? ''}';

    if (name.isEmpty) fields['name'] = 'Informe o nome do pet.';
    if (species != 'dog' && species != 'cat') {
      fields['species'] = 'Espécie inválida.';
    }
    final parsedBirth = _parseDate(birthDate);
    if (parsedBirth == null) {
      fields['birthDate'] = 'Data inválida (use AAAA-MM-DD).';
    } else if (parsedBirth.isAfter(DateTime.now())) {
      fields['birthDate'] = 'Data de nascimento não pode ser futura.';
    }
    if (fields.isNotEmpty) return _validation(fields);

    final breed = '${body['breed'] ?? ''}'.trim();
    final pet = <String, Object?>{
      'id': store.nextPetId(),
      'name': name,
      'species': species,
      'breed': breed.isEmpty ? null : breed,
      'birthDate': birthDate,
      'tutorId': MockStore.userId,
      'summary': store.summaryOf(''), // zerado: pet novo não tem registros
    };
    store.pets.add(pet);
    return json(pet, status: 201);
  });

  router.get('/pets/<petId>', (Request request, String petId) {
    final pet = store.petById(petId);
    if (pet == null) return _notFound('Pet não encontrado');
    // GET /pets/:id não traz summary (API.md).
    return json({...pet}..remove('summary'));
  });

  router.get('/pets/<petId>/summary', (Request request, String petId) {
    if (store.petById(petId) == null) {
      return _notFound('Pet não encontrado');
    }
    return json(store.summaryOf(petId));
  });

  // ── Vacinas ──────────────────────────────────────────────────────────────

  router.get('/pets/<petId>/vaccines', (Request request, String petId) {
    if (store.petById(petId) == null) {
      return _notFound('Pet não encontrado');
    }
    return json(store.vaccinesOf(petId));
  });

  router.post('/pets/<petId>/vaccines', (Request request, String petId) async {
    if (store.petById(petId) == null) return _notFound('Pet não encontrado');

    final body = await _body(request);
    if (body == null) return _badJson();

    final fields = <String, String>{};
    final name = '${body['name'] ?? ''}'.trim();
    final applicationDate = '${body['applicationDate'] ?? ''}';
    final nextDueDate = '${body['nextDueDate'] ?? ''}';

    if (name.isEmpty) fields['name'] = 'Informe o nome da vacina.';
    final app = _parseDate(applicationDate);
    if (app == null) {
      fields['applicationDate'] = 'Data inválida (use AAAA-MM-DD).';
    } else if (app.isAfter(DateTime.now())) {
      fields['applicationDate'] = 'A data não pode ser futura.';
    }
    final due = _parseDate(nextDueDate);
    if (due == null) {
      fields['nextDueDate'] = 'Data inválida (use AAAA-MM-DD).';
    } else if (app != null && due.isBefore(app)) {
      fields['nextDueDate'] = 'Deve ser posterior à data de aplicação.';
    }
    if (fields.isNotEmpty) return _validation(fields);

    final veterinarian = '${body['veterinarian'] ?? ''}'.trim();
    final notes = '${body['notes'] ?? ''}'.trim();
    final vaccine = <String, Object?>{
      'id': store.nextVaccineId(),
      'petId': petId,
      'name': name,
      'applicationDate': applicationDate,
      'nextDueDate': nextDueDate,
      'veterinarian': veterinarian.isEmpty ? null : veterinarian,
      'notes': notes.isEmpty ? null : notes,
    };
    store.vaccines.add(vaccine);
    return json(vaccine, status: 201);
  });

  // ── Consultas ────────────────────────────────────────────────────────────

  router.get('/pets/<petId>/consultations', (Request request, String petId) {
    if (store.petById(petId) == null) {
      return _notFound('Pet não encontrado');
    }
    return json(store.consultationsOf(petId));
  });

  router.post('/pets/<petId>/consultations', (Request request, String petId) async {
    if (store.petById(petId) == null) return _notFound('Pet não encontrado');

    final body = await _body(request);
    if (body == null) return _badJson();

    final fields = <String, String>{};
    final date = '${body['date'] ?? ''}';
    final veterinarian = '${body['veterinarian'] ?? ''}'.trim();
    final reason = '${body['reason'] ?? ''}'.trim();

    final parsedDate = _parseDate(date);
    if (parsedDate == null) {
      fields['date'] = 'Data inválida (use AAAA-MM-DD).';
    } else if (parsedDate.isAfter(DateTime.now())) {
      fields['date'] = 'A data não pode ser futura.';
    }
    if (veterinarian.isEmpty) fields['veterinarian'] = 'Informe o veterinário.';
    if (reason.isEmpty) fields['reason'] = 'Informe o motivo da consulta.';
    if (fields.isNotEmpty) return _validation(fields);

    final notes = '${body['notes'] ?? ''}'.trim();
    final consultation = <String, Object?>{
      'id': store.nextConsultationId(),
      'petId': petId,
      'date': date,
      'veterinarian': veterinarian,
      'reason': reason,
      'notes': notes.isEmpty ? null : notes,
    };
    store.consultations.add(consultation);
    return json(consultation, status: 201);
  });

  // ── Peso ─────────────────────────────────────────────────────────────────

  router.get('/pets/<petId>/weights', (Request request, String petId) {
    if (store.petById(petId) == null) {
      return _notFound('Pet não encontrado');
    }
    return json(store.weightsOf(petId));
  });

  router.post('/pets/<petId>/weights', (Request request, String petId) async {
    if (store.petById(petId) == null) return _notFound('Pet não encontrado');

    final body = await _body(request);
    if (body == null) return _badJson();

    final fields = <String, String>{};
    final date = '${body['date'] ?? ''}';
    final weightKg = body['weightKg'];

    final parsedDate = _parseDate(date);
    if (parsedDate == null) {
      fields['date'] = 'Data inválida (use AAAA-MM-DD).';
    } else if (parsedDate.isAfter(DateTime.now())) {
      fields['date'] = 'A data não pode ser futura.';
    }
    if (weightKg is! num || weightKg <= 0) {
      fields['weightKg'] = 'Informe um peso maior que zero.';
    }
    if (fields.isNotEmpty) return _validation(fields);

    final record = <String, Object?>{
      'id': store.nextWeightId(),
      'petId': petId,
      'date': date,
      'weightKg': (weightKg as num).toDouble(),
    };
    store.weights.add(record);
    return json(record, status: 201);
  });

  // ── Montagem: CORS por fora, auth por dentro ─────────────────────────────
  //
  // CORS é necessário para o app rodar em Flutter Web (localhost → localhost).
  // Auth: tudo exceto /health e /auth/login exige `Authorization: Bearer`.
  return _cors(_withAuth(router, store));
}

/// Middleware de CORS (headers em toda resposta + preflight OPTIONS).
Handler _cors(Handler inner) {
  return (Request request) async {
    if (request.method == 'OPTIONS') {
      return Response.ok('', headers: _corsHeaders());
    }
    final response = await inner(request);
    return response.change(headers: _corsHeaders());
  };
}

/// Envolve o router com a verificação de token (depois do CORS).
Handler _withAuth(Router router, MockStore store) {
  return (Request request) async {
    final path = request.url.path;
    final public =
        path == 'health' ||
        path == 'auth/login' ||
        request.method == 'OPTIONS';
    if (!public) {
      final header = request.headers['authorization'] ?? '';
      if (header != 'Bearer ${MockStore.token}') {
        return _error(
          401,
          'token_expired',
          'Sessão inválida ou expirada. Entre novamente.',
        );
      }
    }
    return router.call(request);
  };
}

// ── Helpers ────────────────────────────────────────────────────────────────

Future<Json?> _body(Request request) async {
  final text = await request.readAsString();
  if (text.isEmpty) return <String, Object?>{};
  try {
    final decoded = jsonDecode(text);
    if (decoded is Map) return Map<String, Object?>.from(decoded);
  } on FormatException {
    return null;
  }
  return null;
}

Json _badJson() => {
  'error': {'code': 'bad_request', 'message': 'Corpo JSON inválido.'},
};

Response json(Object? body, {int status = 200}) => Response(
  status,
  body: jsonEncode(body),
  headers: {'content-type': 'application/json; charset=utf-8'},
);

Response _error(int status, String code, String message) => json({
  'error': {'code': code, 'message': message},
}, status: status);

Response _validation(Map<String, String> fields) => json({
  'error': {
    'code': 'validation_error',
    'message': 'Verifique os campos destacados',
    'fields': fields,
  },
}, status: 422);

Response _notFound(String message) =>
    _error(404, 'not_found', message);

Map<String, String> _corsHeaders() => const {
  'access-control-allow-origin': '*',
  'access-control-allow-methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'access-control-allow-headers': 'Content-Type, Authorization',
};

/// `AAAA-MM-DD` → DateTime, ou null quando inválida.
DateTime? _parseDate(String value) {
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) return null;
  return DateTime.tryParse(value);
}

typedef Json = Map<String, Object?>;
