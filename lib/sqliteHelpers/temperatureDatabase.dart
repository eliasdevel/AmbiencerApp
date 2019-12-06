import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:testing/dataModels/temperatureConfiguration.dart';
import 'package:testing/dataModels/temperatureHistoric.dart';

class TemperatureDatabase {
  static final TemperatureDatabase _instance = TemperatureDatabase._();
  static Database _database;

  TemperatureDatabase._();

  factory TemperatureDatabase() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await init();

    return _database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
    CREATE TABLE temperatureHistoric(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      deviceId TEXT,
      temperature NUMERIC,
      dateTime DATETIME);
       
      
      
  ''');
    print("Database was created!");
  }

  Future<int> addTemperatureHistoric(TemperatureHistoric temperatureHistoric) async {
    var client = await db;
    return client.insert('temperatureHistoric', temperatureHistoric.toMapForDb(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateTemperatureHistoric(TemperatureHistoric obj) async {
    var client = await db;
    return client.update('temperatureHistoric', obj.toMapForDb(), where: 'id = ?', whereArgs: [obj.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeTemperatureHistoric(int id) async {
    var client = await db;
    return client.delete('temperatureHistoric', where: 'id = ?', whereArgs: [id]);
  }


  Future<int> updateTemperatureConfiguration(TemperatureConfiguration obj) async {
    var client = await db;
    return client.update('config', obj.toMapForDb(), where: 'id = ?', whereArgs: [obj.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<TemperatureConfiguration> fetchTemperatureConfiguration(int id) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps = client.query('config', where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return TemperatureConfiguration.fromDb(maps.first);
    }
    return null;
  }

  Future<TemperatureHistoric> fetchTemperatureHistoric(int id) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps = client.query('car', where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return TemperatureHistoric.fromDb(maps.first);
    }
    return null;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    db.execute('''
    
       CREATE TABLE config(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      deviceId TEXT,
      temperature NUMERIC,
      oscilation NUMERIC,
      mode TEXT, /*HEAT or COOL*/
      dateTime DATETIME);
      
        INSERT INTO config(deviceId,temperature,oscilation,mode,dateTime) values(
      'none',
      12.1,
      1,
      'COOL', /*HEAT or COOL*/
      '2019-10-10 00:00:00');
      
  ''');
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = "${directory.path}ambiencer.db";
    var database = openDatabase(
        dbPath, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);

    print('database INITIALIZEDDDD!!!!');
    return database;
  }

  Future<List<TemperatureHistoric>> fetchAllHistorics() async {
    var client = await db;
    var res = await client.query('temperatureHistoric');

    if (res.isNotEmpty) {
      var hist = res.map((carMap) => TemperatureHistoric.fromDb(carMap)).toList();
      return hist;
    }
    return [];
  }
}