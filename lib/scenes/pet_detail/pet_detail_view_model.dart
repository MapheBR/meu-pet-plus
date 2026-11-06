import 'package:meupet_core/meupet_core.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../record_form/record_kind.dart';
import 'pet_detail_coordinator.dart';
import 'server_pet_detail.dart';

/// One card of the Resumo tab, already formatted for the screen.
typedef ResumoCard = ({String title, String subtitle});

/// State and actions of the pet detail scene (abas Resumo/Vacinas/
/// Consultas/Peso).
class PetDetailViewModel extends ChangeNotifier {
  PetDetailViewModel({
    required this.petId,
    required this._server,
    required this._coordinator,
    DateTime? now,
  }) : _now = now ?? DateTime.now();

  final String petId;
  final ServerPetDetail _server;
  final PetDetailCoordinator _coordinator;
  final DateTime _now;

  Pet? _pet;
  PetSummary? _summary;
  List<Vaccine> _vaccines = const [];
  List<Consultation> _consultations = const [];
  List<WeightRecord> _weights = const [];

  int _tab = 0;
  bool _isLoading = false;
  String? _errorMessage;
  bool _disposed = false;

  Pet? get pet => _pet;
  List<Vaccine> get vaccines => _vaccines;
  List<Consultation> get consultations => _consultations;
  List<WeightRecord> get weights => _weights;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedTab => _tab;

  String get petTitle => _pet?.name ?? 'Pet';

  /// "Golden Retriever · 2 anos · 28,4 kg" — subtítulo do cartão do pet
  /// que abre a aba Resumo (protótipo).
  String get petHeaderSubtitle {
    final pet = _pet;
    if (pet == null) return '';
    final parts = [
      pet.breed ?? pet.species.label,
      formatAge(pet.birthDate, now: _now),
    ];
    final kg = _summary?.weight?.currentKg;
    if (kg != null) {
      parts.add('${kg.toStringAsFixed(1).replaceAll('.', ',')} kg');
    }
    return parts.join(' · ');
  }

  // ── Resumo tab ───────────────────────────────────────────────────────────

  /// "V10 — vence em 15 dias (20/11)" — texto do card "Próxima vacina".
  ResumoCard get vaccineCard {
    final next = _summary?.nextVaccine;
    if (next == null) {
      return (
        title: 'Próxima vacina',
        subtitle: 'Nenhuma vacina cadastrada',
      );
    }
    final days = vaccineDaysUntil(next.nextDueDate, now: _now);
    final phrase = switch (vaccineStatusOf(next.nextDueDate, now: _now)) {
      VaccineStatus.upToDate => 'em dia',
      VaccineStatus.dueSoon => 'vence em $days dias',
      VaccineStatus.overdue => 'vencida há ${-days} dias',
    };
    return (
      title: 'Próxima vacina',
      subtitle:
          '${next.name} — $phrase '
          '(${formatDateBr(next.nextDueDate).substring(0, 5)})',
    );
  }

  /// "Rotina — há 3 meses (05/08)" — texto do card "Última consulta".
  ResumoCard get consultationCard {
    final last = _summary?.lastConsultation;
    if (last == null) {
      return (
        title: 'Última consulta',
        subtitle: 'Nenhuma consulta registrada',
      );
    }
    return (
      title: 'Última consulta',
      subtitle:
          '${last.reason} — ${formatRelativePast(last.date, now: _now)} '
          '(${formatDateBr(last.date).substring(0, 5)})',
    );
  }

  /// "28,4 kg · estável nos últimos 2 meses" — texto do card "Peso".
  ResumoCard get weightCard {
    final weight = _summary?.weight;
    if (weight == null) {
      return (title: 'Peso', subtitle: 'Nenhum registro de peso');
    }
    final kg = weight.currentKg.toStringAsFixed(1).replaceAll('.', ',');
    return (title: 'Peso', subtitle: '$kg kg · ${_weightVariationText(weight)}');
  }

  String _weightVariationText(WeightSummary weight) {
    final first = weight.firstDate;
    final last = weight.lastDate;
    final variation = weight.variationKg;
    if (variation == null || first == null || last == null) {
      return last == null ? '' : 'Registro em ${formatDateBr(last)}';
    }
    if (first == last || daysBetween(first, last) < 30) {
      return 'Registro único';
    }
    // Variação pequena → "estável"; senão "+1,2 kg em 5 meses".
    if (variation.abs() < 0.5) {
      final months = (daysBetween(first, last) / 30).floor();
      return months <= 1 ? 'estável' : 'estável nos últimos $months meses';
    }
    final records = _weights;
    if (records.length >= 2) {
      final text = formatWeightVariation(
        records.first.weightKg,
        records.last.weightKg,
        records.first.date,
        records.last.date,
      );
      if (text != null) return text;
    }
    final sign = variation >= 0 ? '+' : '−';
    return '$sign${variation.abs().toStringAsFixed(1).replaceAll('.', ',')} kg';
  }

  // ── Aba Peso ─────────────────────────────────────────────────────────────

  /// Chip do card de peso: "+1,2 kg desde março" (protótipo).
  String? get weightVariationChip {
    final weights = _weights;
    if (weights.length < 2) return null;
    final first = weights.first;
    final last = weights.last;
    final diff = last.weightKg - first.weightKg;
    final sign = diff >= 0 ? '+' : '−';
    final kg = diff.abs().toStringAsFixed(1).replaceAll('.', ',');
    return '$sign$kg kg desde ${monthNamePt(first.date.month)}';
  }

  /// "Último registro · 02/11/2026" do card de peso.
  String? get weightLastRecordText {
    if (_weights.isEmpty) return null;
    return 'Último registro · ${formatDateBr(_weights.last.date)}';
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  Future<void> start() => _load();

  Future<void> retry() => _load();

  void selectTab(int index) {
    _tab = index;
    notifyListeners();
  }

  /// "+" button: abre o formulário do tipo da aba atual (Resumo não tem).
  Future<void> onAddPressed() async {
    final kind = switch (_tab) {
      1 => RecordKind.vaccine,
      2 => RecordKind.consultation,
      3 => RecordKind.weight,
      _ => null,
    };
    if (kind == null) return;
    final created = await _coordinator.goToNewRecord(kind);
    if (created) await _load();
  }

  /// Bottom nav do detalhe (protótipo mostra Início/Perfil também aqui):
  /// 0 = volta à Home na aba Início, 1 = aba Perfil.
  void onNavTap(int tab) => _coordinator.goToHome(tab);

  // ── Loading ──────────────────────────────────────────────────────────────

  /// As 5 chamadas rodam em paralelo, como no app de referência.
  Future<void> _load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final (pet, summary, vaccines, consultations, weights) = await (
      _server.fetchPet(petId),
      _server.fetchSummary(petId),
      _server.fetchVaccines(petId),
      _server.fetchConsultations(petId),
      _server.fetchWeights(petId),
    ).wait;
    _isLoading = false;

    final error =
        pet.errorOrNull ??
        summary.errorOrNull ??
        vaccines.errorOrNull ??
        consultations.errorOrNull ??
        weights.errorOrNull;
    if (error != null) return _fail(error);

    _pet = pet.valueOrNull;
    _summary = summary.valueOrNull;
    _vaccines = vaccines.valueOrNull ?? const [];
    _consultations = consultations.valueOrNull ?? const [];
    _weights = weights.valueOrNull ?? const [];
    notifyListeners();
  }

  Future<void> _fail(AppError error) async {
    if (error is UnauthorizedError) {
      // Token saved but no longer valid (e.g. the server restarted).
      await _server.clearSession();
      _coordinator.goToLogin();
      return;
    }
    _errorMessage = error.message;
    notifyListeners();
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
