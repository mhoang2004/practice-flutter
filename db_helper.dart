import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'champion_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'lol.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE champions(
            id INTEGER PRIMARY KEY,
            name TEXT,
            role TEXT,
            description TEXT
          )
        ''');

        await db.insert('champions', {
          'id': 1,
          'name': 'Garen',
          'role': 'Fighter',
          'description': 'Garen là một chiến binh mạnh mẽ của Demacia.',
        });
      },
    );
  }

  static Future<Champion?> getChampion(int id) async {
    final db = await database;
    final result =
        await db.query('champions', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Champion.fromMap(result.first);
    }
    return null;
  }
}
