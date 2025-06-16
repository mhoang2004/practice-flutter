import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int? id;
  final String fullName;
  final String email;
  final String phone;
  final String birthdate;
  final String gender;
  final String password;
  final DateTime createdAt;

  // ??
  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.gender,
    required this.password,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'birthdate': birthdate,
      'gender': gender,
      'password': password,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['full_name'],
      email: map['email'],
      phone: map['phone'],
      birthdate: map['birthdate'],
      gender: map['gender'],
      password: map['password'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  User copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? birthdate,
    String? gender,
    String? password,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT NOT NULL,
        birthdate TEXT NOT NULL,
        gender TEXT NOT NULL,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // Add a new user
  Future<int> addUser(User user) async {
    final db = await database;
    try {
      return await db.insert('users', user.toMap());
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  // Get user by email and password (for login)
  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Get user by email (to check if email exists)
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user by email: $e');
    }
  }

  // Get user by ID
  Future<User?> getUserById(int id) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user by ID: $e');
    }
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('users');
      return List.generate(maps.length, (i) {
        return User.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  // Update user
  Future<int> updateUser(User user) async {
    final db = await database;
    try {
      return await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user by ID
  Future<int> deleteUser(int id) async {
    final db = await database;
    try {
      return await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Delete user by email
  Future<int> deleteUserByEmail(String email) async {
    final db = await database;
    try {
      return await db.delete(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
    } catch (e) {
      throw Exception('Failed to delete user by email: $e');
    }
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // Get user count
  Future<int> getUserCount() async {
    final db = await database;
    try {
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM users'),
      );
      return count ?? 0;
    } catch (e) {
      throw Exception('Failed to get user count: $e');
    }
  }

  // Search users by name
  Future<List<User>> searchUsersByName(String name) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'full_name LIKE ?',
        whereArgs: ['%$name%'],
      );
      return List.generate(maps.length, (i) {
        return User.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // Delete all users (for testing purposes)
  Future<void> deleteAllUsers() async {
    final db = await database;
    try {
      await db.delete('users');
    } catch (e) {
      throw Exception('Failed to delete all users: $e');
    }
  }
}
