import 'json.dart';

/// The person using the app (the pet's tutor).
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Json json) => User(
    id: json.readString('id'),
    name: json.readString('name'),
    email: json.readString('email'),
    createdAt: json.readDateTime('createdAt'),
  );

  final String id;
  final String name;
  final String email;
  final DateTime createdAt;

  /// First name, used in greetings like "Olá, Ana".
  String get firstName => name.trim().split(RegExp(r'\s+')).first;

  Json toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is User &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, name, email, createdAt);

  @override
  String toString() => 'User($id, $name, $email)';
}
