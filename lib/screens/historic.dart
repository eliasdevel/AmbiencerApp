import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testing/dataModels/temperatureHistoric.dart';
import 'package:testing/screens/chart.dart';
import 'package:testing/sqliteHelpers/temperatureHistoricDAO.dart';

class HistoricScreen extends StatelessWidget {
   String deviceId;
  HistoricScreen(this.deviceId){
    final db = TemperatureHistoricDAO();
    db.test();
  }



  @override
  Widget build(BuildContext context) {
    final db =   TemperatureHistoricDAO();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Gráfico'),
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      ChartScreen(deviceId))),

        )],
        title: Text('Histórico de Temperaturas'),

      ),

      body:
      FutureBuilder<List<TemperatureHistoric>>(
          future:  db.temperatureHistorics(deviceId),
          builder: (context, snapshot) {


            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            return ListView(
              children: snapshot.data
                  .map((historic) => ListTile(
                title: Text(
                    ''
                ),
                subtitle: Text(DateFormat('dd/MM/yyyy H:mm').format(DateTime.parse(historic.dateTime))),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('${historic.temperature.toString()}°c',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      )),
                ),
              ))
                  .toList(),
            );
          },
        ),



      );

  }

}
