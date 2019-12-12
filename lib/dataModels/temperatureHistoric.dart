class TemperatureHistoric {
  final String id;
  final String deviceId;
  final num temperature;
  final String dateTime;

  TemperatureHistoric({this.id, this.deviceId, this.temperature,this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceId': deviceId,
      'temperature': temperature,
      'dateTime': dateTime,
    };
  }

  @override
  String toString() {
    return 'TemperatureHistoric{id: $id, deviceId: $deviceId, temperature: $temperature,dateTime: $dateTime}\n\n';
  }
}
