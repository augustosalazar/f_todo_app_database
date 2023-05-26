import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/random_user.dart';

class UserLocalDataSource {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, gender TEXT, city TEXT, email TEXT, picture TEXT)');
  }

  Future<void> addUser(RandomUser user) async {
    print("Adding user to db");
    final db = await database;

    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RandomUser>> getAllUsers() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('users');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return RandomUser(
        id: maps[i]['id'],
        name: maps[i]['name'],
        gender: maps[i]['gender'],
        email: maps[i]['email'],
        city: maps[i]['city'],
        picture: maps[i]['picture'],
      );
    });
  }

  Future<void> deleteUser(id) async {
    Database db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    Database db = await database;
    await db.delete('users');
  }

  Future<void> updateUser(RandomUser user) async {
    Database db = await database;
    await db.update('users', {'name': user.name, 'city': user.city},
        where: 'id = ?', whereArgs: [user.id]);
  }
}
