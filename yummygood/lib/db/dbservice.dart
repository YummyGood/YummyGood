import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;

class DatabaseService {

  static final _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  static Database? db;

  Future<Database> getDatabase() async{
    if (db != null) return db!;
    print("Initializing database");
    db = await initDatabase();
    return db!;
  }

  Future<Database> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final path = join(await getDatabasesPath(), 'yummygood.db');
    return await openDatabase(path, 
      onCreate: _onCreate,
      version:1
    );
  }

  void _onCreate(Database _db, int version) async{
    await _db.execute('CREATE TABLE Users(email TEXT PRIMARY KEY, first_name TEXT, last_name TEXT, phone TEXT, address TEXT, hash TEXT, salt TEXT)');
    developer.log("Created Users Table");
  }

  void getMovies() async{

  }

}