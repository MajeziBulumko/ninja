// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
// ignore: unused_import
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:think_ninja/models/models.dart';

class DatabaseHelper {
  static int _version = 1;
  static const String _dbName = "grocery.db";
// Here we use one function to create all the database tables we'll need
  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: _version,
      onCreate: (db, version) async {
        await db.execute(''' 
              CREATE TABLE category (
                catid INTEGER PRIMARY KEY,
                categories TEXT NOT NULL,
                )''');
        await db.execute(''' 
              CREATE TABLE store  ( 
                stid INTEGER PRIMARY KEY,
                storeName TEXT NOT NULL,)''');
        await db.execute('''
              CREATE TABLE product (
                id INTEGER PRIMARY KEY, 
                name TEXT NOT NULL, 
                units FLOAT NOT NULL, 
                uom TEXT NOT NULL, 
                price FLOAT NOT NULL,
                ppu FLOAT NOT NULL, 
                stid INTEGER NOT NULL, 
                catid INTEGER NOT NULL, 
                FOREIGN KEY catid REFERENCES category catid ,                
                FOREIGN KEY stid REFERENCES store  stid , )
                 ''');
      },
    );
  }

/*
  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  final _dbName = "grocery.db";
  final _version = 1;

  static Database _db;

  Future<Database> get _getDB async {
    if (_db != null) {
      return _db;
    } else {
      _db = await _initdb();
    }
  }

  _initdb() async {
    Directory docDir = await getDatabasesPath();
    String path = join(docDir.path _dbName);
    return await openDatabase(path, version: _version, onCreate: await onCreate);
  }

  Future onCreate(Database dbs, int version) async{
    await dbs.execute(''' 
              CREATE TABLE category (
                catId INTEGER PRIMARY KEY,
                categories TEXT NOT NULL,
                )''');
        await dbs.execute(''' 
              CREATE TABLE store  ( 
                stId INTEGER PRIMARY KEY,
                storeName TEXT NOT NULL,)''');
        await dbs.execute('''
              CREATE TABLE product (
                id INTEGER PRIMARY KEY, 
                name TEXT NOT NULL, 
                units FLOAT NOT NULL, 
                uoM TEXT NOT NULL, 
                price FLOAT NOT NULL,
                ppu FLOAT NOT NULL, 
                stId INTEGER NOT NULL, 
                catId INTEGER NOT NULL, 
                FOREIGN KEY (catId) REFERENCES category (catId),                
                FOREIGN KEY (stId) REFERENCES store (stId), )
                 ''');
  }
*/
// These functions add to the database tables
  static Future<int> addProduct(Product product) async {
    final db = await _getDB();
    return await db.insert("product", product.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addCategory(Category category) async {
    final db = await _getDB();
    return await db.insert("category", category.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addStore(Store store) async {
    final db = await _getDB();
    return await db.insert("store", store.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

// These funtion update the database tables
  static Future<int> updateProduct(Product product) async {
    final db = await _getDB();
    return await db.update("product", product.toJson(),
        where: "id = ? ",
        whereArgs: [product.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateCategory(Category category) async {
    final db = await _getDB();
    return await db.update("category", category.toJson(),
        where: "catId = ? ",
        whereArgs: [category.catid],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateStore(Store store) async {
    final db = await _getDB();
    return await db.update("store", store.toJson(),
        where: "stId = ? ",
        whereArgs: [store.stid],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

// These functions delete items from all the database tables
  static Future<int> deleteProduct(Product product) async {
    final db = await _getDB();
    return await db.delete(
      "product",
      where: "id = ? ",
      whereArgs: [product.id],
    );
  }

  static Future<int> deleteCategory(Category category) async {
    final db = await _getDB();
    return await db.delete(
      "category",
      where: "catId = ? ",
      whereArgs: [category.catid],
    );
  }

  static Future<int> deleteStore(Store store) async {
    final db = await _getDB();
    return await db.delete(
      "store",
      where: "stId = ? ",
      whereArgs: [store.stid],
    );
  }

// These functions get all the items from a sigula table
  static Future<List<Product>?> getAllProduct() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("product");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Product.fromJson(maps[index]));
  }

  static Future<List<Category>?> getAllCategory() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("category");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => Category.fromJson(maps[index]));
  }

  static Future<List<Store>?> getAllStore() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("store");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Store.fromJson(maps[index]));
  }
// Here we use raw queries to get data that is associated with each other

  static Future<List<Product>?> getAllproductsByCategory(
      Category category) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM product 
      WHERE product.catId = ${category.catid} ''');

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Product.fromJson(maps[index]));
  }

  static Future<List<Product>?> getAllproductsByStore(Store store) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM product 
      WHERE product.stId = ${store.stid} ''');

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Product.fromJson(maps[index]));
  }
}
