/// Form validators. Return `null` when valid, a message in Portuguese
/// otherwise, which is the shape Flutter's `FormField.validator` expects.
library;

final _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
final _apiDatePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Informe o e-mail.';
  if (!_emailPattern.hasMatch(email)) return 'E-mail inválido.';
  return null;
}

String? validatePassword(String? value, {int minLength = 6}) {
  final password = value ?? '';
  if (password.isEmpty) return 'Informe a senha.';
  if (password.length < minLength) {
    return 'A senha precisa ter pelo menos $minLength caracteres.';
  }
  return null;
}

String? validateRequired(String? value, {String field = 'Este campo'}) {
  if (value == null || value.trim().isEmpty) return '$field é obrigatório.';
  return null;
}

/// Accepts `12,5` and `12.5`.
double? parseWeight(String? value) {
  final raw = value?.trim() ?? '';
  if (raw.isEmpty) return null;
  return double.tryParse(raw.replaceAll(',', '.'));
}

/// `YYYY-MM-DD`, not in the future. Returns the parsed date or null.
DateTime? parseApiDateInput(String? value, {bool allowFuture = false}) {
  final raw = value?.trim() ?? '';
  if (!_apiDatePattern.hasMatch(raw)) return null;
  final date = DateTime.tryParse(raw);
  if (date == null) return null;
  if (!allowFuture &&
      date.isAfter(DateTime.now().add(const Duration(days: 1)))) {
    return null;
  }
  return date;
}
