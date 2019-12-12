import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:testing/dataModels/configDevice.dart';
import 'package:testing/sqliteHelpers/temperatureDatabase.dart';

class ConfigDeviceDAO extends DatabaseStart{
  Future<List<ConfigDevice>> configDevices() async {
    // Get a reference to the database.
    final Database db = await getDataBase();

    // Query the table for all The ConfigDevices.
    final List<Map<String, dynamic>> maps = await db.query('configDevices');

    // Convert the List<Map<String, dynamic> into a List<ConfigDevice>.
    return List.generate(maps.length, (i) {
      return ConfigDevice(
        id: maps[i]['id'].toString(),
        deviceId: maps[i]['deviceId'],
        temperature: maps[i]['temperature'],
        oscilation: maps[i]['oscilation'],
        mode: maps[i]['mode'],
      );
    });
  }
  Future<ConfigDevice> getDevice(String deviceId) async{
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db.query('configDevices',
      where: "deviceId = ?",
      whereArgs: [deviceId],
    );

    // Convert the List<Map<String, dynamic> into a List<ConfigDevice>.
    if(maps.length < 1){
      return   ConfigDevice(
        id: 'default',
        deviceId: deviceId,
        temperature: 0,
        oscilation: 0,
        mode: 'COOL',
      );
    }
      return ConfigDevice(
        id: maps[0]['id'].toString(),
        deviceId: maps[0]['deviceId'],
        temperature: maps[0]['temperature'],
        oscilation: maps[0]['oscilation'],
        mode: maps[0]['mode'],
      );
  }

  void test() async {
    var fido = ConfigDevice(
      id: 'default',
      deviceId: 'Fido',
      temperature: 35.5,
      oscilation: 35.5,
      mode: 'COOL',
    );
    // Insert a ConfigDevice into the database.
    await defaultInsert('configDevices', fido);
    // Print the list of ConfigDevices (only Fido for now).
    print(await configDevices());
    // Update Fido's age and save it to the database.
    fido = ConfigDevice(
      id: fido.id,
      deviceId: fido.deviceId,
      temperature: fido.temperature + 7,
      oscilation: fido.oscilation + 7,
      mode: 'HEAT',
    );
    await defaultUpdate('configDevices', fido);
    // Print Fido's updated information.
    print(await configDevices());
    // Delete Fido from the database.
    await defaultDelete('configDevices',fido.id);
    // Print the list of ConfigDevices (empty).
    print(await configDevices());
  }
}