library globals;

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

Map<String, dynamic> vias     = {};
List<dynamic> panel40         = [];
Map<String, dynamic> userfile = {'user':'-'};
BluetoothConnection? connBT;
String user                   = '';
Map<String, dynamic> newBloc  = { 'id': '', 'grade': 'v','owner': '','value': '','name': '','description': ''};

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