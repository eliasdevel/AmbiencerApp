import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing/dataModels/temperatureConfiguration.dart';
import 'package:testing/dataModels/temperatureHistoric.dart';
import 'package:testing/sqliteHelpers/temperatureDatabase.dart';

class ConfigurationForm extends StatefulWidget {
  String deviceId;

  ConfigurationForm(this.deviceId);

  @override
  ConfigurationFormState createState() {
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
  List<TemperatureHistoric> historics = [];
  var db =  TemperatureDatabase();


  final _formKey = GlobalKey<FormState>();
  String deviceId;
  num temperature;
  num oscilation;
//  String dateTime = DateTime.now() as String;
  String _deviceMode = 'COOL';
  ConfigurationFormState(this.deviceId);

  updateConfig(){
    db.updateTemperatureConfiguration(TemperatureConfiguration(1,deviceId,temperature,_deviceMode));
     List<TemperatureConfiguration> ls = db.fetchTemperatureConfiguration(1) as List<TemperatureConfiguration>;
  }
  @override
  Widget build(BuildContext context) {
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
            onChanged: (text) {
              temperature = text as num;
            } ,
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
            onChanged: (text) {
              oscilation = text as num;
            } ,
//            validator: (value) {
//              if (value.isEmpty) {
//                return 'Coloque algum valor';
//              }
//              return null;
//            },
          ),

//              RadioListTile<String>(
//                title: const Text('Resfriar'),
//                value: 'COOL',
//                groupValue: _deviceMode,
//                onChanged: (value) {
//                  setState(() {
//                    _deviceMode = value;
//                  });
//                },
//              ),
//              RadioListTile<String>(
//                title: const Text('Aquecer'),
//                value: 'HEAT',
//                groupValue: _deviceMode,
//                onChanged: (value) {
//                  setState(() {
//                    _deviceMode = value;
//                  });
//                },
//              ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () { updateConfig();
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
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