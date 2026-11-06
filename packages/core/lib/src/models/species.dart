import 'json.dart';

/// Pet species. The API speaks `dog`/`cat`; the screens show
/// "Cachorro"/"Gato" (segmented control of the prototype).
enum PetSpecies {
  dog('dog', 'Cachorro'),
  cat('cat', 'Gato');

  const PetSpecies(this.apiValue, this.label);

  /// Value sent to/received from the API.
  final String apiValue;

  /// Label shown on the screens.
  final String label;

  static PetSpecies? tryParse(String? value) {
    for (final species in values) {
      if (species.apiValue == value) return species;
    }
    return null;
  }

  static PetSpecies fromJson(Json json, String key) {
    final value = json.readString(key);
    final species = tryParse(value);
    if (species == null) {
      throw FormatException('Unknown species "$value" in field "$key"');
    }
    return species;
  }
}
