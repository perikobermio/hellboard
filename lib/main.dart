import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert';
import 'scene_select.dart' as sceneselect;
import 'config.dart' as config;
import 'package:http/http.dart' as http;

import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
 
void main() {
  runApp(const MaterialApp(
    title:  'Hellboard',
    home:   SceneInit(),
  ));
}

Future<Map<String, dynamic>> preLoad() async {
  Map<String, dynamic> ret = {
    'connection': null,
    'vias': null,
  };

  await BluetoothConnection.toAddress(config.btAddress).then((conn) {
    ret['connection'] = conn;  
  }).catchError((e) {
    print('BT conn error');
  });

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final httpPackageUrl            = Uri.parse(config.viasFile);
  final promiseVias               = await http.read(httpPackageUrl);
  Map<String, dynamic> vias      = jsonDecode(promiseVias);

  ret['vias'] = vias;
  
  return ret;
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