import 'dart:convert';

class UserPreferencesModel {
  final int userId;
  final List<String> jobFields;
  final List<String> jobTitles;
  final double expectedSalary;
  final String workMode;
  final String updatedAt;
  
  UserPreferencesModel({
    required this.userId,
    required this.jobFields,
    required this.jobTitles,
    required this.expectedSalary,
    required this.workMode,
    required this.updatedAt,
  });
  
  /// Convert model to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'job_fields': json.encode(jobFields),
      'job_titles': json.encode(jobTitles),
      'expected_salary': expectedSalary,
      'work_mode': workMode,
      'updated_at': updatedAt,
    };
  }
  
  /// Create model from database Map
  factory UserPreferencesModel.fromMap(Map<String, dynamic> map) {
    return UserPreferencesModel(
      userId: map['user_id'],
      jobFields: List<String>.from(json.decode(map['job_fields'])),
      jobTitles: List<String>.from(json.decode(map['job_titles'])),
      expectedSalary: map['expected_salary'],
      workMode: map['work_mode'],
      updatedAt: map['updated_at'],
    );
  }
  
  /// Create a copy with updated fields
  UserPreferencesModel copyWith({
    int? userId,
    List<String>? jobFields,
    List<String>? jobTitles,
    double? expectedSalary,
    String? workMode,
    String? updatedAt,
  }) {
    return UserPreferencesModel(
      userId: userId ?? this.userId,
      jobFields: jobFields ?? this.jobFields,
      jobTitles: jobTitles ?? this.jobTitles,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      workMode: workMode ?? this.workMode,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  /// Convert to JSON string
  String toJson() => json.encode({
    'user_id': userId,
    'job_fields': jobFields,
    'job_titles': jobTitles,
    'expected_salary': expectedSalary,
    'work_mode': workMode,
    'updated_at': updatedAt,
  });
  
  /// Create from JSON string
  factory UserPreferencesModel.fromJson(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    return UserPreferencesModel(
      userId: data['user_id'],
      jobFields: List<String>.from(data['job_fields']),
      jobTitles: List<String>.from(data['job_titles']),
      expectedSalary: data['expected_salary'],
      workMode: data['work_mode'],
      updatedAt: data['updated_at'],
    );
  }
  
  @override
  String toString() {
    return 'UserPreferencesModel(userId: $userId, jobFields: $jobFields, jobTitles: $jobTitles, expectedSalary: $expectedSalary, workMode: $workMode)';
  }
}