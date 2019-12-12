import 'package:flutter/material.dart';
import 'package:testing/screens/configuration.dart';
import 'package:testing/screens/historic.dart';
import 'package:testing/widgets/ServiceTile.dart';
import 'package:testing/widgets/characteristicTile.dart';
import 'package:testing/widgets/descriptorTile.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScreen extends StatelessWidget  {
  const DeviceScreen({Key key, this.device})  : super(key: key);

  final BluetoothDevice device;

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
//    int i = 0;
//    if(services.length >0) {
//      services.forEach((s) {
//        if(s.uuid.toString().length >0){
//          if (s.uuid.toString().toUpperCase().substring(4, 8) != '0001') {
//          services.removeAt(i);
//          }
//        }
//        i++;
//      });
//    }

//    if(services.length >1) {
//      services.removeAt(0);
//      services.removeAt(1);
//    }

    return

      services
        .map(
          (s) => ServiceTile(
            service: s,
            characteristicTiles: s.characteristics

                .map(
                  
                  (c) => CharacteristicTile(

                    characteristic: c,
                    onReadPressed: () => c.read(),
                    onWritePressed: () => c.write([69, 69]),
                    onNotificationPressed: () =>
                        c.setNotifyValue(true),
                    descriptorTiles: c.descriptors
                        .map(
                          (d) => DescriptorTile(
                            descriptor: d,
                            onReadPressed: () => d.read(),
                            onWritePressed: () => d.write([69, 69]),
                          ),
                        )
                        .toList(),
                  ),

                )
//                Filtra Somente A característica 3
//                .where((s) => s.characteristic.uuid.toString().toUpperCase().substring(4, 8) == '0003')
                .toList(),
          ),
        )
        //Filtra Somente o Serviço 1
        .where((s) => s.service.uuid.toString().toUpperCase().substring(4, 8) == '0001')

        .toList();
  }

  @override
  Widget build(BuildContext context) {

    device.discoverServices();
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => device.disconnect();
                  text = 'Desconectar';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => device.connect();
                  text = 'Conectar';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            new ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Histórico de Temperaturas'),

                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              HistoricScreen('${device.id}'))),

                )
              ],
            ), new ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Configuração'),

                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              ConfigurationScreen('${device.id}'))),

                )
              ],
            ),
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => ListTile(
                leading: (snapshot.data == BluetoothDeviceState.connected)
                    ? Icon(Icons.bluetooth_connected)
                    : Icon(Icons.bluetooth_disabled),
                title: Text(
                    'O Dispositivo Está  ${snapshot.data.toString().split('.')[1] == 'connected' ? 'Conectado' : 'Dessconectado'}.'),
                subtitle: Text('${device.id}'),
                trailing: StreamBuilder<bool>(
                  stream: device.isDiscoveringServices,
                  initialData: false,
                  builder: (c, snapshot) => IndexedStack(
                    index: snapshot.data ? 1 : 0,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () => device.discoverServices(),
                      ),
                      IconButton(
                        icon: SizedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.grey),
                          ),
                          width: 18.0,
                          height: 18.0,
                        ),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
//Informações de MTU
//            StreamBuilder<int>(
//              stream: device.mtu,
//              initialData: 0,
//              builder: (c, snapshot) => ListTile(
//                title: Text('MTU Size'),
//                subtitle: Text('${snapshot.data} bytes'),
//                trailing: IconButton(
//                  icon: Icon(Icons.edit),
//                  onPressed: () => device.requestMtu(223),
//                ),
//              ),
//            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
