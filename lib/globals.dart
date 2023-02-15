library globals;

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

Map<String, dynamic> vias   = {};
List<dynamic> panel40       = [];
BluetoothConnection? connBT;
String user                 = '';
Map<String, dynamic> newBloc = { 'id': '', 'grade': 'v','owner': '','value': '','name': '','description': ''};

void clearNewBloc() {
  newBloc = { 'id': '', 'grade': 'v','owner': '','value': '','name': '','description': ''};
}