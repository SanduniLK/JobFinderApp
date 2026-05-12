import 'dart:convert';

import 'package:http/http.dart' as http;

class JobApiService {
  static const String baseUrl = 'https://6a02decc0d92f63dd2545858.mockapi.io';
  
  Future<List<dynamic>> fetchJobs() async {
    print('🔍 ===== FETCHING JOBS =====');
    print('📡 URL: $baseUrl/jobs');
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/jobs'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('📡 Status Code: ${response.statusCode}');
      print('📡 Response Body Length: ${response.body.length}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📡 Data Type: ${data.runtimeType}');
        
        if (data is List) {
          print('✅ SUCCESS! Loaded ${data.length} jobs');
          if (data.isNotEmpty) {
            print('📝 First job: ${data[0]['title']}');
          }
          return data;
        } else {
          print('❌ Data is not a List, it is: ${data.runtimeType}');
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
      }
      return [];
    } catch (e) {
      print('❌ EXCEPTION: $e');
      return [];
    }
  }
}