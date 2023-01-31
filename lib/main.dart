import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
 
void main() {
  runApp(const MyApp());
}
 class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hellboard APP',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const MyHomePage(),
    );
  }
}
 
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  Map _getVias() {
    //File vias = File('assets/vias.json');
    //Map<String, dynamic> oVias = jsonDecode(vias.readAsStringSync());
    Map<String, dynamic> oVias = jsonDecode('{    "vias": {        "v": [            {                "id": 1,                "grade": "V+",                "value": "015-035-165-146-142",                "name": "Danona",                "description": "Errez bat danontzako",                "owner": "Erik"            },            {                "id": 1,                "grade": "V",                "value": "015-135-165-126-144",                "name": "Hasi berriak",                "description": "Hasi berriak",                "owner": "Josu"            }        ],        "vi": [            {                "id": 2,                "grade": "6a",                "value": "015-035-165-146-142",                "name": "Danona",                "description": "Errez bat danontzako",                "owner": "Joseba"            },            {                "id": 3,                "grade": "6b",                "value": "025-065-165-156-142",                "name": "Danona",                "description": "Errez bat danontzako",                "owner": "Gotzon"            }        ],        "vii": [            {                "id": 4,                "grade": "7a",                "value": "015-035-165-146-142",                "name": "Danona",                "description": "Errez bat danontzako",                "owner": "Unai"            },            {                "id": 5,                "grade": "7c",                "value": "025-065-165-156-142",                "name": "Danona",                "description": "Errez bat danontzako",                "owner": "Asier"            }        ],        "viii": [            {                "id": 6,                "grade": "8b+",                "value": "015-035-165-146-142",                "name": "Danona",                "description": "Errez bat danontzako",                "owner": "Eneko"            },            {                "id": 7,                "grade": "8a+",                "value": "025-065-165-156-142",                "name": "Danona",                "description": "Errez bat danontzako",                "owner": "Gaizka"            }        ]    }}');
    return oVias;
  }

  _getDetail(o) {
    List<Widget> items = [];
    const colors = {
      'v': Color.fromARGB(255, 135, 135, 135),
      'v+': Color.fromARGB(255, 135, 135, 135),
      '6a': Color.fromARGB(255, 255, 240, 31),
      '6a+': Color.fromARGB(255, 255, 240, 31),
      '6b': Color.fromARGB(255, 109, 255, 76),
      '6b+': Color.fromARGB(255, 109, 255, 76),
      '6c': Color.fromARGB(255, 91, 225, 255),
      '6c+': Color.fromARGB(255, 91, 225, 255),
      '7a': Color.fromARGB(255, 255, 149, 1),
      '7a+': Color.fromARGB(255, 255, 149, 1),
      '7b': Color.fromARGB(255, 197, 105, 255),
      '7b+': Color.fromARGB(255, 197, 105, 255),
      '7c': Color.fromARGB(255, 252, 64, 64),
      '7c+': Color.fromARGB(255, 252, 64, 64),
      '8a': Color.fromARGB(255, 50, 50, 50),
      '8a+': Color.fromARGB(255, 50, 50, 50),
      '8b': Color.fromARGB(255, 0, 0, 0),
      '8b+': Color.fromARGB(255, 0, 0, 0),
      '8c': Color.fromARGB(255, 0, 0, 0),
      '8c+': Color.fromARGB(255, 0, 0, 0),
    };

    o.forEach((via) => 
      items.add(
        ListTile( 
          leading: Text(via['grade'], style: TextStyle(fontSize: 18, color: colors[via['grade']])),
          title: Text(via['name']),
          subtitle: Text(via['owner']),
          trailing: Icon(Icons.info),
          onTap: () {
            StreamSubscription<BluetoothDiscoveryResult>? conn;
            
            conn = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
              print(r.device.name);
            });
            print(conn);
          }
        )
      )
    );
    return items;
  }
 
  @override
  Widget build(BuildContext context) {
    var oVias = _getVias();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard'),
      ),
      body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
                ExpansionTile(
                    title: Text("V+ (Sako patatas)"),
                    children: _getDetail(oVias['vias']['v'])
                ),
                ExpansionTile(
                    title: Text("6 gradue (Hasi entrenaten)"),
                    children: _getDetail(oVias['vias']['vi']),
                ),
                ExpansionTile(
                    title: Text("7 gradue (Mas fuerte que el vinagre)"),
                    children: _getDetail(oVias['vias']['vii']),
                ),
                ExpansionTile(
                    title: Text("8 (Semidios)"),
                    children: _getDetail(oVias['vias']['viii']),
                ),
               
            ],
        )
      
      )
    );
  }


}