import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'job_finder.db');
    Database db = await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    
    // ✅ Fixed: Call after database is opened
    await _ensureTablesExist(db);
    
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        api_id TEXT,
        created_at TEXT NOT NULL
      )
    ''');
    
    // User Preferences table
    await db.execute('''
      CREATE TABLE user_preferences (
        user_id INTEGER PRIMARY KEY,
        job_fields TEXT NOT NULL,
        job_titles TEXT NOT NULL,
        expected_salary REAL NOT NULL,
        work_mode TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
    
    // Jobs table
    await db.execute('''
      CREATE TABLE jobs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        api_id TEXT,
        title TEXT NOT NULL,
        company TEXT NOT NULL,
        department TEXT NOT NULL,
        job_type TEXT NOT NULL,
        salary TEXT,
        location TEXT NOT NULL,
        description TEXT NOT NULL,
        requirements TEXT,
        posted_by INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER DEFAULT 0
      )
    ''');
  }
  
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_preferences (
          user_id INTEGER PRIMARY KEY,
          job_fields TEXT NOT NULL,
          job_titles TEXT NOT NULL,
          expected_salary REAL NOT NULL,
          work_mode TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');
    }
    
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS jobs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          api_id TEXT,
          title TEXT NOT NULL,
          company TEXT NOT NULL,
          department TEXT NOT NULL,
          job_type TEXT NOT NULL,
          salary TEXT,
          location TEXT NOT NULL,
          description TEXT NOT NULL,
          requirements TEXT,
          posted_by INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          is_synced INTEGER DEFAULT 0
        )
      ''');
    }
  }

  // ✅ Fixed: Pass database as parameter
  Future<void> _ensureTablesExist(Database db) async {
    // Check if user_preferences table exists
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='user_preferences'"
    );
    
    if (result.isEmpty) {
      await db.execute('''
        CREATE TABLE user_preferences (
          user_id INTEGER PRIMARY KEY,
          job_fields TEXT NOT NULL,
          job_titles TEXT NOT NULL,
          expected_salary REAL NOT NULL,
          work_mode TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');
      print('✅ Created missing user_preferences table');
    }
    
    // Check if jobs table exists
    final jobsResult = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='jobs'"
    );
    
    if (jobsResult.isEmpty) {
      await db.execute('''
        CREATE TABLE jobs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          api_id TEXT,
          title TEXT NOT NULL,
          company TEXT NOT NULL,
          department TEXT NOT NULL,
          job_type TEXT NOT NULL,
          salary TEXT,
          location TEXT NOT NULL,
          description TEXT NOT NULL,
          requirements TEXT,
          posted_by INTEGER NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          is_synced INTEGER DEFAULT 0
        )
      ''');
      print('✅ Created missing jobs table');
    }
  }

  // ============ USER OPERATIONS ============
  
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  // ============ USER PREFERENCES ============
  
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    Database db = await database;
    await db.insert(
      'user_preferences',
      preferences,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<Map<String, dynamic>?> fetchUserPreferences(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'user_preferences',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }
  
  // ============ JOB OPERATIONS ============
  
  Future<int> insertJob(Map<String, dynamic> job) async {
    Database db = await database;
    return await db.insert('jobs', job);
  }
  
  Future<int> insertJobs(List<Map<String, dynamic>> jobs) async {
    Database db = await database;
    int count = 0;
    for (var job in jobs) {
      count += await db.insert('jobs', job, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return count;
  }

  Future<List<Map<String, dynamic>>> getAllJobs({
    String? search,
    String? department,
  }) async {
    Database db = await database;
    String sql = 'SELECT * FROM jobs';
    List<String> conditions = [];
    List<dynamic> args = [];

    if (search != null && search.isNotEmpty) {
      conditions.add('(title LIKE ? OR company LIKE ?)');
      args.add('%$search%');
      args.add('%$search%');
    }

    if (department != null && department.isNotEmpty && department != 'All') {
      conditions.add('department = ?');
      args.add(department);
    }

    if (conditions.isNotEmpty) {
      sql += ' WHERE ${conditions.join(' AND ')}';
    }

    sql += ' ORDER BY created_at DESC';
    
    return await db.rawQuery(sql, args);
  }

  Future<Map<String, dynamic>?> getJobById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'jobs',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  

  Future<int> deleteJobById(int id) async {
    Database db = await database;
    return await db.delete('jobs', where: 'id = ?', whereArgs: [id]);
  }
  
  Future<void> clearAllJobs() async {
    Database db = await database;
    await db.delete('jobs');
  }
  // ============ UPDATE METHODS FOR DATABASE HELPER ============

// Add these methods to your existing DatabaseHelper class

// 1. Update User Basic Information
Future<int> updateUser(int userId, Map<String, dynamic> user) async {
  Database db = await database;
  return await db.update(
    'users',
    user,
    where: 'id = ?',
    whereArgs: [userId],
  );
}

// 2. Update User Preferences
Future<int> updateUserPreferences(int userId, Map<String, dynamic> preferences) async {
  Database db = await database;
  return await db.update(
    'user_preferences',
    preferences,
    where: 'user_id = ?',
    whereArgs: [userId],
  );
}

// 3. Update Single Job Field in Preferences
Future<int> updateJobFields(int userId, List<String> jobFields) async {
  Database db = await database;
  return await db.update(
    'user_preferences',
    {'job_fields': json.encode(jobFields), 'updated_at': DateTime.now().toIso8601String()},
    where: 'user_id = ?',
    whereArgs: [userId],
  );
}

// 4. Update Single Job Title in Preferences
Future<int> updateJobTitles(int userId, List<String> jobTitles) async {
  Database db = await database;
  return await db.update(
    'user_preferences',
    {'job_titles': json.encode(jobTitles), 'updated_at': DateTime.now().toIso8601String()},
    where: 'user_id = ?',
    whereArgs: [userId],
  );
}

// 5. Update Expected Salary
Future<int> updateExpectedSalary(int userId, double salary) async {
  Database db = await database;
  return await db.update(
    'user_preferences',
    {'expected_salary': salary, 'updated_at': DateTime.now().toIso8601String()},
    where: 'user_id = ?',
    whereArgs: [userId],
  );
}

// 6. Update Work Mode
Future<int> updateWorkMode(int userId, String workMode) async {
  Database db = await database;
  return await db.update(
    'user_preferences',
    {'work_mode': workMode, 'updated_at': DateTime.now().toIso8601String()},
    where: 'user_id = ?',
    whereArgs: [userId],
  );
}

// 7. Update User Password
Future<int> updateUserPassword(int userId, String newPassword) async {
  Database db = await database;
  return await db.update(
    'users',
    {'password': newPassword},
    where: 'id = ?',
    whereArgs: [userId],
  );
}

// 8. Update User Name Only
Future<int> updateUserName(int userId, String newName) async {
  Database db = await database;
  return await db.update(
    'users',
    {'name': newName},
    where: 'id = ?',
    whereArgs: [userId],
  );
}

// 9. Update User Email Only
Future<int> updateUserEmail(int userId, String newEmail) async {
  Database db = await database;
  return await db.update(
    'users',
    {'email': newEmail},
    where: 'id = ?',
    whereArgs: [userId],
  );
}

// 10. Update Multiple Preferences at Once
Future<int> updateAllPreferences(int userId, {
  List<String>? jobFields,
  List<String>? jobTitles,
  double? expectedSalary,
  String? workMode,
}) async {
  Database db = await database;
  Map<String, dynamic> updates = {};
  
  if (jobFields != null) updates['job_fields'] = json.encode(jobFields);
  if (jobTitles != null) updates['job_titles'] = json.encode(jobTitles);
  if (expectedSalary != null) updates['expected_salary'] = expectedSalary;
  if (workMode != null) updates['work_mode'] = workMode;
  updates['updated_at'] = DateTime.now().toIso8601String();
  
  return await db.update(
    'user_preferences',
    updates,
    where: 'user_id = ?',
    whereArgs: [userId],
  );
}

// 11. Update Job (for job CRUD)
Future<int> updateJob(Map<String, dynamic> job) async {
  Database db = await database;
  return await db.update(
    'jobs',
    job,
    where: 'id = ?',
    whereArgs: [job['id']],
  );
}

// 12. Update Job Sync Status
Future<int> updateJobSyncStatus(int jobId, int isSynced) async {
  Database db = await database;
  return await db.update(
    'jobs',
    {'is_synced': isSynced},
    where: 'id = ?',
    whereArgs: [jobId],
  );
}
}