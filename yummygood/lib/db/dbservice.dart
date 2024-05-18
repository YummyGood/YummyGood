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

    await _db.execute('CREATE TABLE Restaurant(restaurant_id NUMBER PRIMARY KEY, name TEXT, category TEXT, delivery_fee REAL, delivery_time TEXT, picture_url TEXT)');
    developer.log("Created Restaurant Table");

    await _db.execute('CREATE TABLE MenuItem(item_id NUMBER PRIMARY KEY, name TEXT, description TEXT, price REAL, restaurant_id NUMBER, picture_url TEXT)');
    developer.log("Created Menu Item Table");

    await _db.execute('CREATE TABLE CartItem(item_id NUMBER PRIMARY KEY, restaurant_id TEXT, email TEXT, quantity NUMBER)');
    developer.log("Created Cart Table");

    await _db.execute("INSERT INTO Restaurant VALUES(1, 'KFC', 'Fast Food' ,8.95, '20-30 minutes', 'https://tb-static.uber.com/prod/image-proc/processed_images/8fe82646a8a3f13b36e996a83752c618/719c6bd2757b08684c0faae44d43159d.jpeg')");
    await _db.execute("INSERT INTO Restaurant VALUES(2, 'McDonalds', 'Fast Food', 4.99, '10-15 minutes', 'https://tb-static.uber.com/prod/image-proc/processed_images/ceba3c72257138fe56e868d7edf86fc9/c9252e6c6cd289c588c3381bc77b1dfc.jpeg')");
    await _db.execute("INSERT INTO Restaurant VALUES(3, 'Kebab King', 'Kebab', 5.99, '20-30 minutes', 'https://realkebab.com.au/wp-content/uploads/2019/04/HSP-W-CHIPS-X-LARGE.jpg')");

    developer.log("Inserted restaurant data");

    await _db.execute("INSERT INTO MenuItem VALUES(1, '6 Wicked Wings', 'Crispy and Spicy hot golden wings', 9.95, 1, 'https://images.ctfassets.net/crbk84xktnsl/6q2ND6Od6QOZ60AsBvsbur/cb1730822c89ec606dace7fab833f55d/Wicked_Wings_6.png')");
    await _db.execute("INSERT INTO MenuItem VALUES(2, 'Zinger Burger', 'Spicy crispy chicken burger', 7.45, 1, 'https://images.ctfassets.net/crbk84xktnsl/4zgRg2g2ZRBey10D3qfjyZ/e9f079f486f401b884ad570be0a48af8/Zinger_Burger.png')");
    await _db.execute("INSERT INTO MenuItem VALUES(3, '3 Original Tenders', 'Hot and crispy boneless chicken', 4.45, 1, 'https://images.ctfassets.net/crbk84xktnsl/1WeLwRKc8mzxhGmwHq3fb3/97529f19d514bf1a21f4e8169f4dc0ee/Original_Tender_3.png')");

    developer.log("Inserted menu items for KFC");

  }

}