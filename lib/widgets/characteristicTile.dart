import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:testing/dataModels/temperatureHistoric.dart';
import 'package:testing/sqliteHelpers/temperatureHistoricDAO.dart';
import 'descriptorTile.dart';




class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;




  const CharacteristicTile(
      {Key key,
        this.characteristic,
        this.descriptorTiles,
        this.onReadPressed,
        this.onWritePressed,
        this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,

      builder: (c, snapshot) {
        final value = snapshot.data;
        if(characteristic.uuid.toString().toUpperCase().substring(4, 8) == '0003'){
          print('entroooooooo${value.toString()}');
//
        }


        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Canal '),
                Text(
                    'Nr: ${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.body1.copyWith(
                        color: Theme.of(context).textTheme.caption.color))
              ],
            ),

            subtitle: value.length>0? Text('Temperatura :${ascii.decode([value[0],value[1]])}'):Text(''),

            contentPadding: EdgeInsets.all(0.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              characteristic.uuid.toString().toUpperCase().substring(4, 8)== '0002'?
              RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('Ligar'),
                onPressed:
                  onWritePressed
                ,
//                onPressed: onReadPressed,
              ):Text(''),

//              IconButton(
//                icon: Icon(Icons.file_upload,
//                    color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
//                onPressed: onWritePressed,
//              ),
              IconButton(
                icon: Icon(
                    characteristic.isNotifying
                        ? Icons.sync_disabled
                        : Icons.sync,
                    color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
                onPressed: onNotificationPressed,
              )
            ],
          ),
          children: descriptorTiles,
        );
      },
    );
  }
}