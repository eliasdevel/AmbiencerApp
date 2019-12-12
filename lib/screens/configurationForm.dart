import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing/dataModels/configDevice.dart';
import 'package:testing/dataModels/temperatureHistoric.dart';
import 'package:testing/sqliteHelpers/configDeviceDAO.dart';

class ConfigurationForm extends StatefulWidget {
  String deviceId;

  ConfigurationForm(this.deviceId);

  @override
  ConfigurationFormState createState() {
    final db =  ConfigDeviceDAO();
    return ConfigurationFormState(this.deviceId);
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class ConfigurationFormState extends State<ConfigurationForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();


  String deviceId;
  final db =  ConfigDeviceDAO();
  final temperatureController = TextEditingController();
  final oscilationController = TextEditingController();


  ConfigDevice cd;
//  String dateTime = DateTime.now() as String;
  String mode = 'HEAT';
  ConfigurationFormState(this.deviceId);


  void updateConfig() async {
//    cdl = db.configDevices() ;
    if(cd.id == 'default'){
      db.defaultInsert('configDevices', new ConfigDevice(deviceId: deviceId,temperature: num.parse(temperatureController.text ),oscilation: num.parse(oscilationController.text ),mode: mode));
    }else{

      db.defaultUpdate('configDevices', new ConfigDevice(id: cd.id, deviceId: deviceId,temperature: num.parse(temperatureController.text ),oscilation: num.parse(oscilationController.text ),mode: mode));
    }

   print(await db.getDevice(deviceId)) ;
  }

  void setDevice() async{
    cd = await db.getDevice(deviceId);
    temperatureController.text = '${cd.temperature}';
    oscilationController.text = '${cd.oscilation}';
    mode = cd.mode;
//    print(cd);
  }

  @override
  Widget build(BuildContext context) {
    setDevice();
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          Text(),
          Text(this.deviceId),
          TextFormField(

            decoration: InputDecoration(labelText: 'Temperatura:'),
            keyboardType: TextInputType.number,

            controller: temperatureController,
//            validator: (value) {
//              if (value.isEmpty) {
//                return 'Coloque algum valor';
//              }
//              return null;
//            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Oscilação:'),
            keyboardType: TextInputType.number,
            controller: oscilationController ,
//            validator: (value) {
//              if (value.isEmpty) {
//                return 'Coloque algum valor';
//              }
//              return null;
//            },
          ),

          DropdownButton<String>(
            items: [
              DropdownMenuItem<String>(
                child: Text('Aquecer'),
                value: 'HEAT',
              ),
              DropdownMenuItem<String>(
                child: Text('Esfriar'),
                value: 'COOL',
              ),
            ],
            onChanged: (String value) {
              setState(() {
                print(value);
                mode = value;
                updateConfig();
              });
            },
            hint: Text('Select Item'),
            value: mode,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  updateConfig();
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Salvar'),
            ),
          ),
        ],
      ),
    );
  }
}