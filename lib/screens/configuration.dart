import 'package:flutter/material.dart';
import 'package:testing/dataModels/temperatureHistoric.dart';
import 'package:testing/screens/configurationForm.dart';
import 'package:testing/sqliteHelpers/temperatureDatabase.dart';


class ConfigurationScreen extends StatelessWidget {
  final formKey = new GlobalKey<FormState>();
  String deviceId;
  ConfigurationScreen(this.deviceId);

  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Configuração Do dispositivo'),
      ),
      body:  ConfigurationForm(this.deviceId),



    );
  }

}
