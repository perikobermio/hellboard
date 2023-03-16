import 'package:flutter/material.dart';
import 'scene_select.dart' as sceneselect;
import 'dart:core';
import 'globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'config.dart' as config;
import 'package:http/http.dart' as http;

class SceneLogin extends StatefulWidget {
  SceneLogin();

  @override
  State<SceneLogin> createState() => _SceneLogin();
}

class _SceneLogin extends State<SceneLogin> {
  _SceneLogin();

  String? dropdownValue = globals.userfile['user'];

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> computedUsers = [];

    dropdownValue = globals.userfile['user'];
    if(dropdownValue == '') dropdownValue = 'erik';
    
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
                    globals.userfile['user']  = dropdownValue;
                    globals.userfile['vias']  = globals.userViasDone();

                    final userfile = globals.UserFile();
                    userfile.saveUser();

                    final watchUsers = FirebaseDatabase.instance.ref("messages/${globals.userfile['user']}");
                    watchUsers.onChildChanged.listen((event) {
                      loadMessages();
                    });

                    loadMessages().then((res) => Navigator.push(context,MaterialPageRoute(builder: (context) => sceneselect.SceneSelectHome())));
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

Future<void> loadMessages() async {
  final httpPackageUrl  = Uri.parse('${config.messagesFile}/${globals.userfile['user']}.json');
  final promiseUsers    = await http.read(httpPackageUrl);
  final json            = jsonDecode(promiseUsers);
  
  if(json != null) {
    globals.messages    = json;
  }
}