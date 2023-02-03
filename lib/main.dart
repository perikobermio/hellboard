import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'scene_select.dart' as sceneselect;
import 'config.dart' as config;
 
void main() {
  runApp(const MaterialApp(
    title:  'Navigation Basics',
    home:   SceneInit(),
  ));
}

Future<Map<String, dynamic>> preLoad() async {
  BluetoothConnection connection  = await BluetoothConnection.toAddress(config.btAddress);

  final httpPackageUrl            = Uri.parse(config.viasFile);
  final promiseVias               = await http.read(httpPackageUrl);
  Map<String, dynamic> oVias      = jsonDecode(promiseVias);

  return {
    'connection': connection,
    'vias':       oVias
  };
}

class SceneInit extends StatelessWidget {
  const SceneInit({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: preLoad(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          return MaterialApp(
            title: 'Hellboard APP',
            theme: ThemeData(
              primarySwatch: Colors.lightGreen,
            ),
            home: sceneselect.SceneSelectHome(
              connection: snapshot.data?['connection'], 
              oVias: snapshot.data?['vias']
            )
          );

        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}