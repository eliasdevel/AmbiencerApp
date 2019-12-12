class ConfigDevice {
  final String id;
  final String deviceId;
  final num temperature;
  final num oscilation;
  final String mode;

  ConfigDevice({this.id, this.deviceId, this.temperature,this.oscilation,this.mode});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deviceId': deviceId,
      'temperature': temperature,
      'oscilation': oscilation,
      'mode': mode,
    };
  }

  @override
  String toString() {
    return 'ConfigDevice{id: $id, deviceId: $deviceId, temperature: $temperature,oscilation: $oscilation, mode: $mode}';
  }
}