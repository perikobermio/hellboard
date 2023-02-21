import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
//import 'scene_select.dart' as sceneselect;
import 'scene_login.dart' as scenelogin;
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() {
  runApp(MaterialApp(
    title:  'Hellboard',
    home:   SceneInit(),
  ));
}

Future<void> preLoad() async {
  if(globals.connBT == null) {
    await BluetoothConnection.toAddress(config.btAddress).then((conn) {
      globals.connBT = conn;
    }).catchError((e) {
      print('BT conn error');
    });
  }

  if(Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  if(globals.vias.isEmpty) {
    final httpPackageUrl            = Uri.parse(config.viasFile);
    final promiseVias               = await http.read(httpPackageUrl);
    globals.vias                    = jsonDecode(promiseVias);
  }

  if(globals.users.isEmpty) {
    final httpPackageUrl            = Uri.parse(config.usersFile);
    final promiseUsers              = await http.read(httpPackageUrl);
    globals.users                   = jsonDecode(promiseUsers);
  }

  if(globals.panel40.isEmpty) {
    final String response = await rootBundle.loadString('assets/panel40.json');
    globals.panel40       = jsonDecode(response);
  }
}

class SceneInit extends StatefulWidget {
  @override
  State<SceneInit> createState() => _SceneInit();
}

class _SceneInit extends State<SceneInit> {
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: preLoad(),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Hellboard APP',
          theme: ThemeData(
            primarySwatch: Colors.lightGreen,
          ),
          //home: sceneselect.SceneSelectHome()
          home: scenelogin.SceneLogin()
        );
      }
    );
  }
}