import 'package:flutter/material.dart';
import 'package:testing/dataModels/temperatureHistoric.dart';
import 'package:testing/sqliteHelpers/temperatureDatabase.dart';


class HistoricScreen extends StatelessWidget {
  HistoricScreen(){
    final db = TemperatureDatabase();

//    db.addTemperatureHistoric(TemperatureHistoric());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Temperaturas'),
      ),
      body: SingleChildScrollView(child: Text("aa"),



      ),


    );
  }

}
