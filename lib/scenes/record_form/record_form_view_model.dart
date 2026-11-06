import 'package:meupet_core/meupet_core.dart';
import 'package:flutter/foundation.dart';

import 'record_form_coordinator.dart';
import 'record_kind.dart';
import 'server_record_form.dart';

/// State and actions of the record form (vacina, consulta ou peso).
/// Uma cena só: os três formulários do protótipo têm os mesmos campos
/// (datas + textos) e o mesmo POST → 201/422.
class RecordFormViewModel extends ChangeNotifier {
  RecordFormViewModel({
    required this.kind,
    required this.petId,
    required this._server,
    required this._coordinator,
  });

  /// Qual formulário abrir (vaccine, consultation ou weight).
  final RecordKind kind;

  /// Pet dono do registro.
  final String petId;

  final ServerRecordForm _server;
  final RecordFormCoordinator _coordinator;

  // Textos digitados.
  String _name = '';
  String _veterinarian = '';
  String _reason = '';
  String _notes = '';
  String _weightInput = '';

  // Datas escolhidas no date picker.
  DateTime? _applicationDate;
  DateTime? _nextDueDate;
  DateTime? _consultationDate;
  DateTime? _weightDate;

  bool _isLoading = false;
  String? _errorMessage;
  final Map<String, String> _fieldErrors = {};
  bool _disposed = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? fieldError(String field) => _fieldErrors[field];

  // Vacina.
  String get name => _name;
  DateTime? get applicationDate => _applicationDate;
  DateTime? get nextDueDate => _nextDueDate;

  // Consulta.
  DateTime? get consultationDate => _consultationDate;
  String get veterinarian => _veterinarian;
  String get reason => _reason;
  String get notes => _notes;

  // Peso.
  DateTime? get weightDate => _weightDate;
  String get weightInput => _weightInput;

  // ── Actions ──────────────────────────────────────────────────────────────

  void onNameChanged(String value) {
    _name = value;
    _clearFieldError('name');
  }

  void onVeterinarianChanged(String value) {
    _veterinarian = value;
    _clearFieldError('veterinarian');
  }

  void onReasonChanged(String value) {
    _reason = value;
    _clearFieldError('reason');
  }

  void onNotesChanged(String value) => _notes = value;

  void onWeightChanged(String value) {
    _weightInput = value;
    _clearFieldError('weightKg');
  }

  void onApplicationDateChanged(DateTime date) {
    _applicationDate = date;
    _clearFieldError('applicationDate');
  }

  void onNextDueDateChanged(DateTime date) {
    _nextDueDate = date;
    _clearFieldError('nextDueDate');
  }

  void onConsultationDateChanged(DateTime date) {
    _consultationDate = date;
    _clearFieldError('date');
  }

  void onWeightDateChanged(DateTime date) {
    _weightDate = date;
    _clearFieldError('date');
  }

  Future<void> save() async {
    if (_isLoading) return;

    _fieldErrors.clear();
    _validateLocally();
    if (_fieldErrors.isNotEmpty) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _saveOnServer();

    _isLoading = false;
    switch (result) {
      case Ok():
        _coordinator.goBack(created: true);
      case Failure(error: ValidationError(:final fields, :final message)):
        // O 422 da API aponta o campo; mostro a mensagem nele.
        _fieldErrors.addAll(fields);
        _errorMessage = message;
        notifyListeners();
      case Failure(:final error):
        _errorMessage = error.message;
        notifyListeners();
    }
  }

  // ── Validação local (a API valida de novo e devolve 422) ─────────────────

  void _validateLocally() {
    final now = DateTime.now();
    bool notFuture(DateTime? d) =>
        d != null && d.isAfter(now.add(const Duration(days: 1)));

    switch (kind) {
      case RecordKind.vaccine:
        if (_name.trim().isEmpty) {
          _fieldErrors['name'] = 'Informe o nome da vacina.';
        }
        if (_applicationDate == null) {
          _fieldErrors['applicationDate'] = 'Informe a data de aplicação.';
        } else if (notFuture(_applicationDate)) {
          _fieldErrors['applicationDate'] = 'A data não pode ser futura.';
        }
        if (_nextDueDate == null) {
          _fieldErrors['nextDueDate'] = 'Informe a próxima dose.';
        } else if (notFuture(_nextDueDate!)) {
          // Próxima dose PODE ser futura — só não pode ser antes da aplicação.
        }
        if (_applicationDate != null &&
            _nextDueDate != null &&
            _nextDueDate!.isBefore(_applicationDate!)) {
          _fieldErrors['nextDueDate'] =
              'Deve ser posterior à data de aplicação.';
        }
      case RecordKind.consultation:
        if (_consultationDate == null) {
          _fieldErrors['date'] = 'Informe a data da consulta.';
        } else if (notFuture(_consultationDate)) {
          _fieldErrors['date'] = 'A data não pode ser futura.';
        }
        if (_veterinarian.trim().isEmpty) {
          _fieldErrors['veterinarian'] = 'Informe o veterinário.';
        }
        if (_reason.trim().isEmpty) {
          _fieldErrors['reason'] = 'Informe o motivo da consulta.';
        }
      case RecordKind.weight:
        if (_weightDate == null) {
          _fieldErrors['date'] = 'Informe a data.';
        } else if (notFuture(_weightDate)) {
          _fieldErrors['date'] = 'A data não pode ser futura.';
        }
        final kg = parseWeight(_weightInput);
        if (kg == null) {
          _fieldErrors['weightKg'] = 'Informe o peso em kg.';
        } else if (kg <= 0) {
          _fieldErrors['weightKg'] = 'O peso precisa ser maior que zero.';
        }
    }
  }

  Future<Result<void>> _saveOnServer() => switch (kind) {
    RecordKind.vaccine => _server.saveVaccine(
      petId,
      name: _name,
      applicationDate: _applicationDate!,
      nextDueDate: _nextDueDate!,
      veterinarian: _veterinarian,
      notes: _notes,
    ),
    RecordKind.consultation => _server.saveConsultation(
      petId,
      date: _consultationDate!,
      veterinarian: _veterinarian,
      reason: _reason,
      notes: _notes,
    ),
    RecordKind.weight => _server.saveWeight(
      petId,
      date: _weightDate!,
      weightKg: parseWeight(_weightInput)!,
    ),
  };

  void _clearFieldError(String field) {
    if (_fieldErrors.remove(field) != null) notifyListeners();
  }

  /// Answers can arrive after the screen closed; ignore them then.
  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
