library globals;

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';

Map<String, dynamic> vias         = {};
Map<String, dynamic> users        = {};
List<dynamic> panel40             = [];
Map<String, dynamic> userfile     = {'user':'', 'data': {}, 'vias': {}};
BluetoothConnection? connBT;
Map<String, dynamic> newBloc      = { 'id': '', 'grade': 'v','owner': '','value': '','name': '','description': '', 'rating': 0};

Map userViasDone() {
  return users[userfile['user']]['vias'];
}

Map userViasRate() {
  return users[userfile['user']]['rating'];
}

void clearNewBloc() {
  newBloc = { 'id': '', 'grade': 'v','owner': '','value': '','name': '','description': '', 'rating': 0};
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



String getGrade(String? grade) {
  String ret  = 'v';
  List six    = ['6a','6a+','6b','6b+','6c','6c+'];
  List seven  = ['7a','7a+','7b','7b+','7c','7c+'];
  List eight  = ['8a','8a+','8b','8b+','8c','8c+'];
  List nine   = ['9a','9a+','9b','9b+','9c','9c+'];

  if(six.contains(grade)) {           ret = 'vi';
  } else if(seven.contains(grade)) {  ret = 'vii';
  } else if(eight.contains(grade)) {  ret = 'viii';
  } else if(nine.contains(grade)) {   ret = 'ix'; }

  return ret;
}

class ViasActions {

  Future<void> insertVia(grade) async {
    int key                   = 0;
    Map<String, Map> updates  = {};

    if(!vias.containsKey(grade)) { //ezpadauen gradue
      updates[grade] = {};
      updates[grade]?[key.toString()]   = newBloc;

      FirebaseDatabase.instance.ref('/vias/').update(updates);
      vias[grade] = [];
      vias[grade].add(newBloc);
    } else { //gradue badauen
      key = vias[grade].length;
      updates[key.toString()] = newBloc;
    
      FirebaseDatabase.instance.ref('/vias/$grade/').update(updates);
      vias[grade].add(newBloc);
    }
  }

  Future<void> updateVia(grade, oldGrade) async {
    if(oldGrade == grade) {
      int index = vias[grade].indexWhere((i) => i['id'] == newBloc['id']);
      vias[grade][index] = newBloc;

      DatabaseReference ref = FirebaseDatabase.instance.ref("vias/$grade/$index");
      await ref.set(newBloc);
    } else {
      int index = vias[oldGrade].indexWhere((i) => i['id'] == newBloc['id']);
      vias[oldGrade].removeAt(index);
      DatabaseReference ref = FirebaseDatabase.instance.ref("vias/$oldGrade");
      await ref.set(vias[oldGrade]);
      insertVia(grade);
    }
  }
  Future<void> deleteVia(grade, id) async {
    int index = vias[grade].indexWhere((i) => i['id'] == id);
    vias[grade].removeAt(index);
    DatabaseReference ref = FirebaseDatabase.instance.ref("vias/$grade");
    await ref.set(vias[grade]);
  }
}



class FireActions {

  Future<void> set(path, value) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    await ref.set(value);
  }

}