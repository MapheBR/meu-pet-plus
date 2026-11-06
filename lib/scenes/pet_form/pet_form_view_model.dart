import 'package:meupet_core/meupet_core.dart';
import 'package:flutter/foundation.dart';

import 'pet_form_coordinator.dart';
import 'server_pet_form.dart';

/// State and actions of the "Novo pet" form.
class PetFormViewModel extends ChangeNotifier {
  PetFormViewModel({required this._server, required this._coordinator});

  final ServerPetForm _server;
  final PetFormCoordinator _coordinator;

  String _name = '';
  PetSpecies _species = PetSpecies.dog;
  String _breed = '';
  DateTime? _birthDate;

  bool _isLoading = false;
  String? _errorMessage;
  final Map<String, String> _fieldErrors = {};
  bool _disposed = false;

  String get name => _name;
  PetSpecies get species => _species;
  String get breed => _breed;
  DateTime? get birthDate => _birthDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? fieldError(String field) => _fieldErrors[field];

  static const speciesOptions = [PetSpecies.dog, PetSpecies.cat];

  // ── Actions ──────────────────────────────────────────────────────────────

  void onNameChanged(String value) {
    _name = value;
    _clearFieldError('name');
  }

  void onBreedChanged(String value) {
    _breed = value;
    _clearFieldError('breed');
  }

  void onSpeciesSelected(int index) {
    _species = speciesOptions[index];
    notifyListeners();
  }

  void onBirthDateChanged(DateTime date) {
    _birthDate = date;
    _clearFieldError('birthDate');
  }

  Future<void> save() async {
    if (_isLoading) return;

    // Validação local primeiro; a API valida de novo (422).
    _fieldErrors
      ..clear()
      ..addAll({
        if (_name.trim().isEmpty) 'name': 'Informe o nome do pet.',
        if (_birthDate == null) 'birthDate': 'Informe a data de nascimento.',
        if (_birthDate != null &&
            _birthDate!.isAfter(DateTime.now()))
          'birthDate': 'A data não pode ser futura.',
      });
    if (_fieldErrors.isNotEmpty) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _server.createPet(
      name: _name,
      species: _species,
      breed: _breed,
      birthDate: _birthDate!,
    );

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
