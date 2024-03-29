import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert';

import 'scene_login.dart' as scenelogin;
import 'config.dart' as config;
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() {
  runApp(MaterialApp(
    title:  'Hellboard',
    home:   SceneInit(),
  ));
}

Future<void> loadVias() async {
  final httpPackageUrl = Uri.parse(config.viasFile);
  final promiseVias    = await http.read(httpPackageUrl);
  globals.vias         = jsonDecode(promiseVias);

  globals.orderVias();
}

Future<void> loadPanels(panel) async {
  final httpPackageUrl      = Uri.parse('${config.rtd}$panel.json');
  final promise             = await http.read(httpPackageUrl);
  globals.panels[panel]     = jsonDecode(promise);
}

Future<void> loadUsers() async {
  final httpPackageUrl = Uri.parse(config.usersFile);
  final promiseUsers   = await http.read(httpPackageUrl);
  globals.users        = jsonDecode(promiseUsers);
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
    await loadVias();
    final watchVias = FirebaseDatabase.instance.ref("blocs");
    watchVias.onChildChanged.listen((event) {
      loadVias();
    });
  }

  if(globals.users.isEmpty) {
    await loadUsers();
    final watchUsers = FirebaseDatabase.instance.ref("users");
    watchUsers.onChildChanged.listen((event) {
      loadUsers();
    });
  }

  if(globals.panels.isEmpty) {
    loadPanels('panel40');
    loadPanels('panel30');
    loadPanels('panel20a');
    loadPanels('panel20b');
  }

  final userfile = globals.UserFile();
  await userfile.preparePersonal();

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
        if(snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Hellboard APP',
            theme: ThemeData(
              primarySwatch: Colors.lightGreen,
            ),
            home: scenelogin.SceneLogin()
          );
        } else {
          return CircularProgressIndicator(); 
        }
      }
    );
  }
}