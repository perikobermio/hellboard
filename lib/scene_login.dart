import 'package:flutter/material.dart';
import 'scene_select.dart' as sceneselect;
import 'config.dart' as config;
import 'dart:core';
import 'globals.dart' as globals;

class SceneLogin extends StatefulWidget {
  SceneLogin();

  @override
  State<SceneLogin> createState() => _SceneLogin();
}

class _SceneLogin extends State<SceneLogin> {
  _SceneLogin();

  String? dropdownValue = 'erik';

  @override
  Widget build(BuildContext context) {

    globals.user  = dropdownValue!;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.person),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Color.fromARGB(255, 45, 188, 90),
                ),
                onChanged: (String? value) {
                  setState(() {
                    globals.user  = value.toString();
                    dropdownValue = value;
                  });
                
                },
                items: config.users.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value['value'],
                    child: Text(value['label']),
                  );
                }).toList(),
              ),
              SizedBox(width: 15),
              OutlinedButton(
                onPressed: () {
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