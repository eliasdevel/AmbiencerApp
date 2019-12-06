import 'package:flutter/cupertino.dart';

class TemperatureConfiguration {
  @required
  final int id;
  @required
  final String deviceId;
  @required
  final num temperature;
  @required
  final String mode;

  TemperatureConfiguration(this.id, this.deviceId, this.temperature, this.mode);

  TemperatureConfiguration.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        deviceId = map['deviceId'],
        temperature = map['temperature'],
        mode = map['mode'];

//  TemperatureConfiguration(this.id, this.deviceId, this.temperature, this.dateTime);

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['deviceId'] = deviceId;
    map['temperature'] = temperature;
    map['dateTime'] = mode;
    return map;
  }



}
