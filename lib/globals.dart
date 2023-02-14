library globals;

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

Map<String, dynamic> vias = {};
List<dynamic> panel40     = [];
List<String> currentBloc  = [];
BluetoothConnection? connBT;
String user               = '';