import 'package:meupet_core/meupet_core.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'home_coordinator.dart';
import 'server_home.dart';

/// Health state of a pet card — mirrors the three vaccine chips of the
/// prototype, plus "no records".
enum PetHealth { ok, warning, overdue, none }

extension on VaccineStatus {
  PetHealth get toPetHealth => switch (this) {
    VaccineStatus.upToDate => PetHealth.ok,
    VaccineStatus.dueSoon => PetHealth.warning,
    VaccineStatus.overdue => PetHealth.overdue,
  };
}

/// One pet row of the Home, already formatted for the screen.
typedef HomePet = ({
  String id,
  String name,
  String subtitle,
  PetHealth health,
  String healthLabel,
});

/// State and actions of the home scene ("Meus pets" tab).
class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required this._serverHome,
    required this._coordinator,
    DateTime? now,
  }) : _now = now ?? DateTime.now();

  final ServerHome _serverHome;
  final HomeCoordinator _coordinator;
  final DateTime _now;

  int _tab = 0;
  bool _isLoading = false;
  String? _errorMessage;
  List<HomePet> _pets = const [];
  bool _disposed = false;

  int get selectedTab => _tab;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<HomePet> get pets => _pets;

  // ── Actions ──────────────────────────────────────────────────────────────

  Future<void> start() => _load();

  Future<void> retry() => _load();

  void selectTab(int index) {
    _tab = index;
    notifyListeners();
  }

  void onAddPressed() => _coordinator.goToNewPet().then(_reloadIf);

  /// Pet card tapped: reloads the list when something changed there.
  Future<void> onPetTapped(String id) async {
    final changed = await _coordinator.goToPetDetail(id);
    if (changed) await _load();
  }

  // ── Loading ──────────────────────────────────────────────────────────────

  Future<void> _load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _serverHome.fetchPets();
    _isLoading = false;
    switch (result) {
      case Ok(:final value):
        _pets = [for (final pet in value) _toHomePet(pet)];
        notifyListeners();
      case Failure(error: UnauthorizedError()):
        // Token saved but no longer valid (e.g. the server restarted).
        await _serverHome.clearSession();
        _coordinator.goToLogin();
      case Failure(:final error):
        _errorMessage = error.message;
        notifyListeners();
    }
  }

  Future<void> _reloadIf(bool changed) async {
    if (changed) await _load();
  }

  // ── Mapping Core models → screen data ────────────────────────────────────

  HomePet _toHomePet(Pet pet) {
    final vaccine = pet.summary?.nextVaccine;
    final (health, label) = switch (vaccine) {
      null => (PetHealth.none, 'Sem registro de vacina'),
      _ => _healthOf(vaccine.nextDueDate),
    };
    return (
      id: pet.id,
      name: pet.name,
      subtitle: _subtitle(pet),
      health: health,
      healthLabel: label,
    );
  }

  /// Chip rule of API.md: vencida < hoje, "em breve" até 30 dias, senão em dia.
  (PetHealth, String) _healthOf(DateTime nextDueDate) {
    final status = vaccineStatusOf(nextDueDate, now: _now);
    final label = switch (status) {
      VaccineStatus.overdue => 'Vacina vencida',
      VaccineStatus.dueSoon => 'Vacina vence em breve',
      VaccineStatus.upToDate => 'Vacina em dia',
    };
    return (status.toPetHealth, label);
  }

  String _subtitle(Pet pet) {
    final parts = [
      pet.species.label,
      ?pet.breed,
      formatAge(pet.birthDate, now: _now),
    ];
    return parts.join(' · ');
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
