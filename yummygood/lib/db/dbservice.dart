import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    await _db.execute('CREATE TABLE Users(username TEXT PRIMARY KEY, hash TEXT, salt TEXT)');
    print("Created Users Table");
  }

  void getMovies() async{

  }

}