library globals;

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:io';
import 'config.dart' as config;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';

Map<String, dynamic>  vias         = {};
Map<String, dynamic>  users        = {};
Map<String, dynamic>  messages     = {};

List<dynamic>         panel40      = [];
Map<String, dynamic>  panels       = {};

Map<String, dynamic>  userfile     = {'user':'', 'data': {}, 'vias': {}};
BluetoothConnection?  connBT;
Map<String, dynamic>  newBloc      = { 'id': '', 'grade': 'v','owner': '','value': '','name': '','description': '', 'panel': 'panel40', 'rating': 0};

Map userViasDone() {
  return users[userfile['user']]['vias'];
}

Map userViasRate() {
  return users[userfile['user']]['rating'];
}

void clearNewBloc() {
  newBloc = { 'id': '', 'grade': 'v','owner': '','value': '','name': '','description': '', 'panel': 'panel40', 'rating': 0};
}

Map<String,dynamic> getVia(id) {
  Map<String,dynamic> ret = {};

  for(var i in vias.values) {
    if(i.keys.contains(id)) {
      ret = i[id];
      break;
    }
  }
  
  return ret;
}

void orderVias() {
  Map<String, dynamic> temp = {};
  for(var grade in vias.keys) {
    temp        = vias[grade];
    temp        = Map.fromEntries(temp.entries.toList()..sort((a,b) => a.value['grade'].compareTo(b.value['grade'])));
    vias[grade] = temp;
  }
}

class UserFile {

  Future<File> get _personalFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path      = directory.path;
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
  } else if(nine.contains(grade)) {   ret = 'viiii'; }

  return ret;
}

Future<void> cleanBloc(key) async {
  FireActions fa  = FireActions();

  delete(user,v) {
    fa.delete('users/$user/rating/$key');
    fa.delete('users/$user/vias/$key');
  }

  users.forEach((k,v) => delete(k,v));
}

class FireActions {

  Future<void> set(path, value) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    await ref.set(value);
  }

  Future<void> delete(path) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    await ref.remove();
  }

  Future<bool> toggle(path) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    var a = await ref.get();
    bool status;

    if(a.value == null) {
      await ref.set(true);
      status = true;
    } else {
      await ref.remove();
      status = false;
    }
    return status;
  }  

}

class Messaging {
  Future<void> done(createdBy, via) async {
    sendMessage(createdBy, via, 'done');
  }

  Future<void> create(createdBy, via) async {
    sendMessage(createdBy, via, 'create');
  }

  Future<void> modify(createdBy, via) async {
    sendMessage(createdBy, via, 'modify');
  }

  Future<void> sendMessage(createdBy, via, type) async {
    FireActions fa  = FireActions();
    String now      = DateTime.now().millisecondsSinceEpoch.toString();

    users.forEach((key, user) => {
      if(userfile['user'] != key) {
        fa.set('messages/$key/$type/$now', getMessage(now, createdBy, via, type))
      }
    });
  }

  Map getMessage(id, createdBy, via, type) {
    String grade  = getGrade(via['grade']);
    String msg    = '';

    if(type == 'done') {
      msg = "${users[createdBy]['label'].toUpperCase()} artistiek '${vias[grade][via['id']]['name']} (${vias[grade][via['id']]['grade']})' blokie ataratie lortu dau!";
    } else if(type == 'create') {
      msg = "${users[createdBy]['label'].toUpperCase()} artistiek '${vias[grade][via['id']]['name']}' izeneko blokie sortu dau. Bota biztazo bat '${vias[grade][via['id']]['grade']}' da ta!";
    } else if(type == 'modify') {
      msg = "${users[createdBy]['label'].toUpperCase()} artistiek '${vias[grade][via['id']]['name']}' izeneko blokie aldatu dau. Bota biztazo bat ia '${vias[grade][via['id']]['grade']}' gradue dekota biher bada!";
    }

    return {'id': id,'status': 1,'msg': msg, 'viaid': via['id']};
  }
}

Future<void> loadMessages() async {
  final httpPackageUrl  = Uri.parse('${config.messagesFile}/${userfile['user']}.json');
  final promiseUsers    = await http.read(httpPackageUrl);
  final json            = jsonDecode(promiseUsers);
  
  if(json != null) {
    messages    = json;
  }
}