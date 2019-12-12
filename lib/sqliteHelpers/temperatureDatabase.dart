import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseStart{
   Future<Database> getDataBase() async{
     return openDatabase(
       // Set the path to the database. Note: Using the `join` function from the
       // `path` package is best practice to ensure the path is correctly
       // constructed for each platform.
       join(await getDatabasesPath(), 'ambiencer2.db'),
       // When the database is first created, create a table to store dogs.
       onCreate: (db, version) {
          db.execute(
           "CREATE TABLE configDevices(id INTEGER PRIMARY KEY AUTOINCREMENT, deviceId TEXT, temperature NUMERIC, oscilation NUMERIC,mode TEXT)"

         );
          db.execute("CREATE TABLE temperatureHistorics(id INTEGER PRIMARY KEY AUTOINCREMENT, deviceId TEXT, temperature NUMERIC, dateTime DATETIME);");
       },
       // Set the version. This executes the onCreate function and provides a
       // path to perform database upgrades and downgrades.
       version: 5,
     );
   }

   Future<void> defaultInsert( String table, var obj) async {
     // Get a reference to the database.
     final Database db = await getDataBase();

     // multiple times, it replaces the previous data.
     await db.insert(
       table,
       obj.toMap(),
       conflictAlgorithm: ConflictAlgorithm.replace,
     );
   }
   Future<void> defaultUpdate(String table, var obj) async {
     // Get a reference to the database.
     final db = await getDataBase();
     // Update the given ConfigDevice.
     await db.update(
       table,
       obj.toMap(),
       where: "id = ?",
       whereArgs: [obj.id],
     );
   }
   Future<void> defaultDelete(String table,  String id) async {
     final db = await getDataBase();
     await db.delete(
       table,
       where: "id = ?",
       whereArgs: [id],
     );
   }
}

