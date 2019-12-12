import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:testing/screens/findDevices.dart';
import 'package:testing/screens/bluetooth.dart';
import 'package:cron/cron.dart';
import 'package:testing/sqliteHelpers/temperatureHistoricDAO.dart';

import 'dataModels/temperatureHistoric.dart';

void main() {

  runApp(

      FlutterAmbiencerApp()
  );
}

class FlutterAmbiencerApp extends StatelessWidget {
   String tempe ='0';
   String deviceId ='teste';
   bool started = false;
   final db =   TemperatureHistoricDAO();

   updateTemperature(String deviceId) async {

    var date = new DateTime.now();

    TemperatureHistoric t = new TemperatureHistoric(
        deviceId: deviceId,
        temperature: num.parse(tempe),
        dateTime: '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')} ${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}'
    );
//    sleep( new Duration(seconds: 1) );
     TemperatureHistoric th = await db.getLastTemperature(deviceId);
     print("dataaaa");
     print(th.dateTime);

     if(  th.dateTime != t.dateTime && tempe !='0') {
       db.defaultInsert('temperatureHistorics', t);
     }
//    if(await db.getLastTemperature(deviceId) != t && tempe !='0') {
//
//    }
    print( await db.getLastTemperature(deviceId));
  }

 Future characteristicCheck(BluetoothCharacteristic characteristic) async{
    if(characteristic.uuid.toString().toUpperCase().substring(4, 8) =='0003'){
      if(!characteristic.isNotifying) {
        await characteristic.setNotifyValue(true);
        characteristic.value.listen((value) {
        print('Data-received_______________________${value.toString()}');
          if (value.length > 0) {
            tempe = ascii.decode([value[0], value[1]]);
          }
          print(tempe);
        });
      }
    }
  }
 Future serviceCheck(BluetoothService service) async{
    if(  service.uuid.toString().toUpperCase().substring(4, 8) == '0001'){
      var characteristics = service.characteristics;
      for(BluetoothCharacteristic c in characteristics) {
        characteristicCheck(c);
      }
    }
  }
 Future deviceCheck(BluetoothDevice device) async{
    started = true;
     deviceId = device.id.toString();
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      this.serviceCheck(service);
    });

  }

 Future startBluethoothCheck() async{

       final List<BluetoothDevice> ls = await FlutterBlue.instance
           .connectedDevices;
       ls.forEach((device) =>
           this.deviceCheck(device)
       );


  }


  @override
  Widget build(BuildContext context) {

    var cron = new Cron();

    cron.schedule(new Schedule.parse('*/1 * * * *'), (){
      if(!started) {
        startBluethoothCheck();
      }
      updateTemperature( deviceId);
    });




    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }


}







