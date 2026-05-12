import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://reqres.in/api';
  static const String apiKey = 'reqres_31e3fb1ddb1e47848c88446a42a94823';
  
  
  Future<Map<String, dynamic>?> register(String name, String email, String password) async {
    log(' API Register called');
    log(' Email: $email');
    log(' URL: $baseUrl/register');
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
        },
        body: json.encode({
          'email': email,  
          'password': password,
        }),
      );
      
      log('Status: ${response.statusCode}');
      log('Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log(' API Register Success! ID: ${data['id']}');
        return {
          'success': true,
          'id': data['id'].toString(),
          'token': data['token'],
        };
      } else {
        log('API Register Failed: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Registration failed. Please try again.',
        };
      }
    } catch (e) {
      log(' API Register Error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
  
  Future<Map<String, dynamic>?> login(String email, String password) async {
    log('API Login called');
    log('Email: $email');
    log('URL: $baseUrl/login');
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
        },
        body: json.encode({
          'email': email,  
          'password': password,
        }),
      );
      
      log('Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log('API Login Success!');
        return {
          'success': true,
          'token': data['token'],
        };
      } else {
        log('API Login Failed');
        return {
          'success': false,
          'message': 'Invalid credentials',
        };
      }
    } catch (e) {
      log('API Login Error: $e');
      return {
        'success': false,
        'message': 'Network error',
      };
    }
  }
  Future<bool> deleteUserAccount(String userId) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
    );
    return response.statusCode == 200 || response.statusCode == 204;
  } catch (e) {
    print('API delete user error: $e');
    return false;
  }
}
}