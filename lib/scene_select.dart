import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';
import 'scene_add.dart' as sceneadd;

class SceneSelectHome extends StatelessWidget {
  final BluetoothConnection? connection;
  final Map<String, dynamic>? oVias;
  SceneSelectHome({required this.connection, required this.oVias});

  bool isConnected() {
    return connection != null;
  }

  _getGrade(vias) {
    List<Widget> items = [];

    vias.forEach((k, g) => {
        items.add(
          ExpansionTile(
            title: Text(k.toUpperCase()),
            children: _getDetail(g)
          )
        )
    });

    return items;
  }

  _getDetail(grade) {
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

    grade.forEach((via) => {
        items.add(
          ListTile( 
            leading: Text(via['grade'], style: TextStyle(fontSize: 18, color: colors[via['grade']])),
            title: Text(via['name']),
            subtitle: Text(via['owner']),
            trailing: Icon(Icons.info),
            onTap: () {
              String viavalue = via["value"];
              String pitch = 'load:$viavalue';
              
              Uint8List uint8list = Uint8List.fromList(pitch.codeUnits);
              connection?.output.add(uint8list);
            }
          )
        )
    });

    return items;
  }
 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Bloke barrije',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const sceneadd.SceneAdd()),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: isConnected() ? const Icon(Icons.bluetooth) : const Icon(Icons.bluetooth_disabled),
              tooltip: 'Konekzinue',
              onPressed: () {
                print('BT: trying to connect');
              },
            ),
          ),
        ]
      ),
      body: Container(
          color: Colors.white,
          child: ListView(
            children: _getGrade(oVias)
        )
      
      )
    );
  }
}