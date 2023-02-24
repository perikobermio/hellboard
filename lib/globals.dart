library globals;

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

Map<String, dynamic> vias         = {};
Map<String, dynamic> users        = {};
List<dynamic> panel40             = [];
Map<String, dynamic> userfile     = {'user':'', 'data': {}};
BluetoothConnection? connBT;

Map<String, dynamic> newBloc      = { 'id': '', 'grade': 'v','owner': '','value': '','name': '','description': ''};

void clearNewBloc() {
  newBloc = { 'id': '', 'grade': 'v','owner': '','value': '','name': '','description': ''};
}

void orderVias() {
  List<dynamic> temp = [];
  for(var grade in vias.keys) {
    temp = vias[grade];
    temp.sort((a,b) => a['grade'].compareTo(b['grade']));
    vias[grade] = temp;
  }
}

class UserFile {

  Future<File> get _personalFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/personal.json');
  }

  Future<void> preparePersonal() async {
    try {
      final file          = await _personalFile;
      String contents     = '';

      if (await file.exists()) {
        contents          = await file.readAsString();
        userfile          = jsonDecode(contents);
      } else {
        await file.writeAsString(json.encode(userfile));
      }
    } catch (e) {
      print('personal.json FAIL');
    }
  }

  Future<void> saveUser() async {
    final file          = await _personalFile;
    await file.writeAsString(json.encode(userfile));
  }

}