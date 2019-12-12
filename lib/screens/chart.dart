import 'package:flutter/material.dart';
import 'package:testing/dataModels/temperatureHistoric.dart';
import 'package:testing/sqliteHelpers/temperatureHistoricDAO.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartScreen extends StatelessWidget {
  String deviceId;
  List<GraphicData> data;

  List<charts.Series<dynamic, DateTime>> seriesList;

  ChartScreen(this.deviceId) {
//    db.test();
  }

  Future<List<GraphicData>> getData() async {
    final db = TemperatureHistoricDAO();
    List<TemperatureHistoric> th = await db.temperatureHistorics(deviceId);
    print(th);
    data = [new GraphicData(DateTime.parse(th[0].dateTime), th[0].temperature)];
    for(TemperatureHistoric t in th){
      data.add(new GraphicData(DateTime.parse(t.dateTime), t.temperature));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Temperaturas'),
      ),
      body: FutureBuilder<List<GraphicData>>(
          future:  getData(),
          builder: (BuildContext context, AsyncSnapshot<List<GraphicData>> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return Container(
              child: charts.TimeSeriesChart(
                [
                  charts.Series<GraphicData, DateTime>(
                    id: 'Temperatura',
                    colorFn: (_, __) =>
                        charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (GraphicData his, _) => his.time,
                    measureFn: (GraphicData his, _) => his.temperature,
                    data: snapshot.data,
                  )
                ],
                animate: false,
              ),
            );
//          ,
          }),
    );
  }
}

class GraphicData {
  final DateTime time;
  final num temperature;

  GraphicData(this.time, this.temperature);
}
