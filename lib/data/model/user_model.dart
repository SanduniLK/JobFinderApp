import 'package:job_finder/domain/entities/user.dart';

class UserModel extends User {
  final String password;

   UserModel({
    super.id,
    required super.name,
    required super.email,
    required this.password,
    super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'created_at': createdAt,
    };
  }
}