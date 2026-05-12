import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:job_finder/data/local/database_helper.dart';
import 'package:job_finder/data/model/user_preferences_model.dart';
import 'package:job_finder/data/remote/api_service.dart';
import 'package:job_finder/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final ApiService _apiService = ApiService();
  
  User? _currentUser;
  UserPreferencesModel? _userPreferences;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isOnline = false;  

  
  User? get currentUser => _currentUser;
  UserPreferencesModel? get userPreferences => _userPreferences;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isOnline => _isOnline;
  
  List<String> _selectedJobFields = [];
  List<String> _selectedJobTitles = [];
  double _expectedSalary = 50000;
  String _workMode = 'Remote';
  String? _tempName;
  String? _tempEmail;
  String? _tempPassword;

  List<String> get selectedJobFields => _selectedJobFields;
  List<String> get selectedJobTitles => _selectedJobTitles;
  double get expectedSalary => _expectedSalary;
  String get workMode => _workMode;

  AuthProvider() {
    _checkAuthStatus();
    _checkConnectivity();
  }


  Future<void> _checkConnectivity() async {
    await _updateConnectivityStatus();
 
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _updateConnectivityStatus();
    });
  }
  
  Future<void> _updateConnectivityStatus() async {
    bool wasOnline = _isOnline;
    _isOnline = await _hasRealInternet();
    
    if (wasOnline != _isOnline) {
      log('Connection changed: ${_isOnline ? "ONLINE" : "OFFLINE"}');
      notifyListeners();
    }
  }
  
  Future<bool> _hasRealInternet() async {
  try {
    
    final results = await Future.wait([
      InternetAddress.lookup('google.com').timeout(const Duration(seconds: 2)),
      InternetAddress.lookup('cloudflare.com').timeout(const Duration(seconds: 2)),
      InternetAddress.lookup('8.8.8.8').timeout(const Duration(seconds: 2)),
    ]);
    
    return results.any((result) => result.isNotEmpty && result[0].rawAddress.isNotEmpty);
  } on SocketException catch (_) {
    return false;
  } on TimeoutException catch (_) {
    return false;
  } catch (_) {
    return false;
  }
}

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    
    if (userId != null) {
      final userData = await _databaseHelper.getUserById(userId);
      if (userData != null) {
        _currentUser = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
        );
        await _loadUserPreferences(userId);
        notifyListeners();
      }
    }
  }
  
  Future<void> _loadUserPreferences(int userId) async {
    final prefsData = await _databaseHelper.fetchUserPreferences(userId);
    if (prefsData != null) {
      _userPreferences = UserPreferencesModel.fromMap(prefsData);
      log('Loaded preferences from SQLite');
    }
  }

  void saveStep1Data(String name, String email, String password) {
    _tempName = name;
    _tempEmail = email;
    _tempPassword = password;
    log(' Step 1 saved: $email');
  }
  
  void toggleJobField(String field) {
    if (_selectedJobFields.contains(field)) {
      _selectedJobFields.remove(field);
    } else {
      _selectedJobFields.add(field);
    }
    notifyListeners();
  }
  
  void toggleJobTitle(String title) {
    if (_selectedJobTitles.contains(title)) {
      _selectedJobTitles.remove(title);
    } else {
      _selectedJobTitles.add(title);
    }
    notifyListeners();
  }
  
  void updateSalary(double salary) {
    _expectedSalary = salary;
    notifyListeners();
  }
  
  void updateWorkMode(String mode) {
    _workMode = mode;
    notifyListeners();
  }
  
  
  Future<bool> completeSignUp() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      log(' SIGN UP - Real connection: ${_isOnline ? "ONLINE" : "OFFLINE"}');
      log('Email: $_tempEmail');
      
      
      final existingUser = await _databaseHelper.getUserByEmail(_tempEmail!);
      if (existingUser != null) {
        _errorMessage = 'Email already registered';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      int userId;
      
      
      if (_isOnline) {
        log('🌐 ONLINE MODE: Calling ReqRes API...');
        
        try {
          final result = await _apiService.register(
            _tempName!,
            _tempEmail!,
            _tempPassword!,
          ).timeout(const Duration(seconds: 10));
          
          if (result != null && result['success'] == true) {
            log(' API registration successful!');
            
            final userMap = {
              'name': _tempName,
              'email': _tempEmail,
              'password': _tempPassword,
              'api_id': result['id'],
              'created_at': DateTime.now().toIso8601String(),
            };
            userId = await _databaseHelper.insertUser(userMap);
            log('User saved to SQLite cache');
          } else {
            _errorMessage = 'API registration failed';
            _isLoading = false;
            notifyListeners();
            return false;
          }
        } catch (e) {
          _errorMessage = 'API error: ${e.toString()}';
          log('❌ API error: $e');
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        
        log('📱 OFFLINE MODE: Saving to SQLite only (NO API CALL)');
        
        final userMap = {
          'name': _tempName,
          'email': _tempEmail,
          'password': _tempPassword,
          'created_at': DateTime.now().toIso8601String(),
        };
        userId = await _databaseHelper.insertUser(userMap);
        log(' User saved to SQLite (offline mode, no API)');
      }
      
     
      final preferencesMap = {
        'user_id': userId,
        'job_fields': json.encode(_selectedJobFields),
        'job_titles': json.encode(_selectedJobTitles),
        'expected_salary': _expectedSalary,
        'work_mode': _workMode,
        'updated_at': DateTime.now().toIso8601String(),
      };
      await _databaseHelper.saveUserPreferences(preferencesMap);
      log('Preferences saved to SQLite');
      
      _currentUser = User(
        id: userId,
        name: _tempName!,
        email: _tempEmail!,
      );
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      await prefs.setString('user_name', _tempName!);
      await prefs.setString('user_email', _tempEmail!);
      
      
      _tempName = null;
      _tempEmail = null;
      _tempPassword = null;
      _selectedJobFields = [];
      _selectedJobTitles = [];
      _expectedSalary = 50000;
      _workMode = 'Remote';
      
      _isLoading = false;
      notifyListeners();
      log('SIGN UP COMPLETED!');
      return true;
      
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      log('Sign up error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    log(' SIGN IN - Real connection: ${_isOnline ? "ONLINE" : "OFFLINE"}');

    try {
      
      if (!_isOnline) {
        log('OFFLINE MODE: Checking SQLite only (NO API CALL)');
        
        final userData = await _databaseHelper.getUserByEmail(email);
        
        if (userData == null) {
          _errorMessage = 'User not found. Please go online to register.';
          _isLoading = false;
          notifyListeners();
          return false;
        }

        if (userData['password'] != password) {
          _errorMessage = 'Invalid password';
          _isLoading = false;
          notifyListeners();
          return false;
        }

        _currentUser = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
        );
        
        await _loadUserPreferences(userData['id']);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', userData['id']);
        
        _isLoading = false;
        notifyListeners();
        log('OFFLINE sign in successful!');
        return true;
      }
      
      
      log('ONLINE MODE: Calling ReqRes API...');
      
      final result = await _apiService.login(email, password);
      
      if (result == null || result['success'] != true) {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      log(' API login successful!');
      
      var userData = await _databaseHelper.getUserByEmail(email);
      
      if (userData == null) {
      
        final userMap = {
          'name': email.split('@')[0],
          'email': email,
          'password': password,
          'api_token': result['token'],
          'created_at': DateTime.now().toIso8601String(),
        };
        final userId = await _databaseHelper.insertUser(userMap);
        userData = await _databaseHelper.getUserById(userId);
        log('User cached to SQLite');
      }
      
      _currentUser = User(
        id: userData!['id'],
        name: userData['name'],
        email: userData['email'],
      );
      
      await _loadUserPreferences(userData['id']);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userData['id']);
      
      _isLoading = false;
      notifyListeners();
      log('ONLINE sign in successful!');
      return true;
      
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      log(' Sign in error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
void updateCurrentUser({required String name, required String email}) {
  if (_currentUser != null) {
    _currentUser = User(
      id: _currentUser!.id,
      name: name,
      email: email,
      createdAt: _currentUser!.createdAt,
    );
    notifyListeners();
    
    
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('user_name', name);
      prefs.setString('user_email', email);
    });
  }
}
Future<void> refreshUser() async {
  if (_currentUser != null) {
    final userData = await _databaseHelper.getUserById(_currentUser!.id!);
    if (userData != null) {
      _currentUser = User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        createdAt: userData['created_at'],
      );
      notifyListeners();
    }
  }
}
Future<void> updateUserPreferences({
  required List<String> jobFields,
  required List<String> jobTitles,
  required double expectedSalary,
  required String workMode,
}) async {
  if (_currentUser != null) {
    
    final preferencesMap = {
      'user_id': _currentUser!.id,
      'job_fields': json.encode(jobFields),
      'job_titles': json.encode(jobTitles),
      'expected_salary': expectedSalary,
      'work_mode': workMode,
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    await _databaseHelper.updateUserPreferences(_currentUser!.id!, preferencesMap);
    
   
    _userPreferences = UserPreferencesModel(
      userId: _currentUser!.id!,
      jobFields: jobFields,
      jobTitles: jobTitles,
      expectedSalary: expectedSalary,
      workMode: workMode,
      updatedAt: DateTime.now().toIso8601String(),
    );
    
    
    notifyListeners();
    
    log(' User preferences updated and notified');
  }
}


Future<void> reloadPreferences() async {
  if (_currentUser != null) {
    final prefsData = await _databaseHelper.fetchUserPreferences(_currentUser!.id!);
    if (prefsData != null) {
      _userPreferences = UserPreferencesModel.fromMap(prefsData);
      notifyListeners();
      print('Preferences reloaded: ${_userPreferences?.jobFields}');
    } else {
      print('No preferences found for user ${_currentUser!.id}');
    }
  }
}
  
 
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
    _userPreferences = null;
    notifyListeners();
    log('👋 User logged out');
  }
  Future<bool> deleteAccount() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
  
    final userId = _currentUser?.id;
    final apiId = _currentUser?.id?.toString(); 
    
    if (userId == null) {
      _errorMessage = 'User not found';
      _isLoading = false;
      notifyListeners();
      return false;
    }
    
  
    if (_isOnline) {
      try {
        final apiDeleted = await _apiService.deleteUserAccount(userId.toString());
        if (apiDeleted) {
          print('Account deleted from API');
        } else {
          print(' API delete failed, but continuing with local delete');
        }
      } catch (e) {
        print(' API delete error: $e, continuing with local delete');
      }
    }
    
    
    final localDeleted = await _databaseHelper.deleteUser(userId);
    
    if (localDeleted > 0) {
      print(' Account deleted from SQLite');
      
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      
      _currentUser = null;
      _userPreferences = null;
      
      _isLoading = false;
      notifyListeners();
      
      return true;
    } else {
      _errorMessage = 'Failed to delete account from local database';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  } catch (e) {
    _errorMessage = 'Error deleting account: ${e.toString()}';
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
}