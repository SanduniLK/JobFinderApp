import 'package:job_finder/data/local/database_helper.dart';
import 'package:job_finder/data/model/user_model.dart';

import 'package:job_finder/domain/entities/user.dart';
import 'package:job_finder/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<User?> signIn(String email, String password) async {
    final userData = await _databaseHelper.getUserByEmail(email);
    
    if (userData == null) return null;
    if (userData['password'] != password) return null;
    
    // Save session
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userData['id']);
    await prefs.setString('user_name', userData['name']);
    await prefs.setString('user_email', userData['email']);
    
    return User(
      id: userData['id'],
      name: userData['name'],
      email: userData['email'],
      createdAt: userData['created_at'],
    );
  }

  @override
  Future<User?> signUp(String name, String email, String password) async {
    final existingUser = await _databaseHelper.getUserByEmail(email);
    if (existingUser != null) return null;
    
    final userModel = UserModel(
      name: name,
      email: email,
      password: password,
    );
    
    final userId = await _databaseHelper.insertUser(userModel.toMap());
    
    // Save session
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    
    return User(
      id: userId,
      name: name,
      email: email,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') != null;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}