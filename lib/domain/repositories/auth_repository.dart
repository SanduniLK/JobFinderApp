import 'package:job_finder/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String name, String email, String password);
  Future<bool> isLoggedIn();
  Future<void> logout();
}