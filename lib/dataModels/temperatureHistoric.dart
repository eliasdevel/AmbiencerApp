import 'package:flutter/cupertino.dart';

class TemperatureHistoric {
  @required
  final int id;
  @required
  final String deviceId;
  @required
  final num temperature;
  @required
  final String dateTime;

  TemperatureHistoric(this.id, this.deviceId, this.temperature, this.dateTime);

  TemperatureHistoric.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        deviceId = map['deviceId'],
        temperature = map['temperature'],
        dateTime = map['dateTime'];

//  TemperatureHistoric(this.id, this.deviceId, this.temperature, this.dateTime);

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['deviceId'] = deviceId;
    map['temperature'] = temperature;
    map['dateTime'] = dateTime;
    return map;
  }



}
