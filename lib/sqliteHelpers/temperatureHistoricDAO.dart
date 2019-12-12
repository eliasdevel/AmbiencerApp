import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:testing/dataModels/temperatureHistoric.dart';
import 'package:testing/sqliteHelpers/temperatureDatabase.dart';

class TemperatureHistoricDAO extends DatabaseStart{
  Future<List<TemperatureHistoric>> temperatureHistorics(String deviceId) async {
    // Get a reference to the database.
    final Database db = await getDataBase();

    // Query the table for all The TemperatureHistorics.
    final List<Map<String, dynamic>> maps = await db.query('temperatureHistorics',where: 'deviceId = ?',whereArgs: [deviceId]);

    // Convert the List<Map<String, dynamic> into a List<TemperatureHistoric>.
    return List.generate(maps.length, (i) {
      return TemperatureHistoric(
        id: maps[i]['id'].toString(),
        deviceId: maps[i]['deviceId'],
        temperature: maps[i]['temperature'],
        dateTime: maps[i]['dateTime'],
      );
    });
  }

  Future<TemperatureHistoric> getLastTemperature(String deviceId) async{
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('select * from temperatureHistorics where deviceId = \'${deviceId}\' order by id desc limit 1');

    // Convert the List<Map<String, dynamic> into a List<TemperatureHistoric>.
    if(maps.length < 1){
      return   TemperatureHistoric(
        id: 'default',
        deviceId: deviceId,
        temperature: 0,
        dateTime: '',
      );
    }
      return TemperatureHistoric(
        id: maps[0]['id'].toString(),
        deviceId: maps[0]['deviceId'],
        temperature: maps[0]['temperature'],
        dateTime: maps[0]['dateTime'],
      );
  }

  void clear() async{
    final Database db = await getDataBase();

    db.rawQuery("DELETE FROM temperatureHistorics");

  }

  void test() async {
    var date = new DateTime.now();
    var fido = TemperatureHistoric(
      deviceId: 'Fido',
      temperature: 35.5,
      dateTime: date.toString()
    );
    // Insert a TemperatureHistoric into the database.
    await defaultInsert('temperatureHistorics', fido);
    // Print the list of TemperatureHistorics (only Fido for now).
    print(await temperatureHistorics(fido.id));
    // Update Fido's age and save it to the database.
    fido = TemperatureHistoric(
      id: fido.id,
      deviceId: fido.deviceId,
      temperature: fido.temperature + 7,
      dateTime: 'a'
    );
    await defaultUpdate('temperatureHistorics', fido);
    // Print Fido's updated information.
    print(await temperatureHistorics(fido.id));
    // Delete Fido from the database.
    await defaultDelete('temperatureHistorics',fido.deviceId);
    // Print the list of TemperatureHistorics (empty).
    print(await temperatureHistorics(fido.deviceId));
  }
}