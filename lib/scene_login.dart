import 'package:flutter/material.dart';
import 'scene_select.dart' as sceneselect;
import 'config.dart' as config;
import 'dart:core';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'globals.dart' as globals;

class SceneLogin extends StatefulWidget {
  SceneLogin();

  final userfile = UserFile();

  @override
  State<SceneLogin> createState() => _SceneLogin();
}

class _SceneLogin extends State<SceneLogin> {
  _SceneLogin();

  String? dropdownValue = globals.userfile['user'];

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> computedUsers = [];

    dropdownValue = globals.userfile['user'];
    widget.userfile.preparePersonal();

    for(var key in globals.users.keys) {
      computedUsers.add(DropdownMenuItem<String>(
        value: key,
        child: Text(globals.users[key]['label']),
      ));
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Image(image: AssetImage('assets/img/logoh.png'))
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.person),
                elevation: 16,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                underline: Container(
                  height: 2,
                  color: Color.fromARGB(255, 45, 188, 90),
                ),
                onChanged: (String? value) {
                  setState(() {
                    globals.userfile['user']  = value.toString();
                    globals.userfile['data']  = globals.users[globals.userfile['user']];
                    dropdownValue             = globals.userfile['user'];
                  });
                
                },
                items: computedUsers,
              ),
              SizedBox(width: 15),
              OutlinedButton(
                onPressed: () {
                  globals.userfile['user'] = dropdownValue;
                  widget.userfile.saveUser();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sceneselect.SceneSelectHome()),
                  );
                },
                child: const Text('Sartun'),
              )
            ],
          )
        ],
      )
    );
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
        globals.userfile  = jsonDecode(contents);
      } else {
        await file.writeAsString(json.encode(globals.userfile));
      }
    } catch (e) {
      print('personal.json FAIL');
    }
  }

  Future<void> saveUser() async {
    final file          = await _personalFile;
    await file.writeAsString(json.encode(globals.userfile));
  }

}