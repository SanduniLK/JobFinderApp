class User {
  final int? id;
  final String name;
  final String email;
  final String? createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    this.createdAt,
  });
}