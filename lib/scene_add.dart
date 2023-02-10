import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:core';
import 'config.dart' as config;
import 'globals.dart' as globals;
import 'main.dart' as sceneinit;
import 'scene_panel.dart' as scenepanel;
import 'package:firebase_database/firebase_database.dart';

class SceneAdd extends StatefulWidget {
  SceneAdd();

  @override
  State<SceneAdd> createState() => _SceneAdd();
}

class _SceneAdd extends State<SceneAdd> {
  final GlobalKey<FormState> formKey = GlobalKey();

  Map<String, String> newBloc = { 'id': '', 'grade': '','owner': '','value': '','name': '','description': ''};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard geitxu Blokie'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Form(
              key: formKey,
              child: Column(
              children: <Widget>[

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      initialValue: 'v+',
                      icon: Icon(Icons.grade),
                      labelText: 'Gradue',
                      items: config.grades,
                      onChanged: (val) => newBloc['grade'] = val
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: IconButton(
                      icon: const Icon(Icons.sports_score),
                      tooltip: 'Aukeratu blokie',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => scenepanel.ScenePanel()),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Blokie',
                      ),
                      onChanged: (val) {
                          newBloc['value'] = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Izena',
                      ),
                      onChanged: (val) {
                        newBloc['name'] = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Deskribapena',
                      ),
                      onChanged: (val) {
                        newBloc['description'] = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      initialValue: '-',
                      icon: Icon(Icons.person),
                      labelText: 'Egilea',
                      items: config.users,
                      onChanged: (val) => newBloc['owner'] = val
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 68),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      onPressed: () {
                        newBloc['id'] = DateTime.now().millisecondsSinceEpoch.toString();

                        String grade = getGrade(newBloc['grade']);
                        int key = globals.vias[grade].length;
                        final Map<String, Map> updates = {};

                        updates[key.toString()] = newBloc;

                        globals.vias[grade].add(newBloc);
                        FirebaseDatabase.instance.ref('/vias/$grade/').update(updates);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => sceneinit.SceneInit()),
                        );
                      },
                      child: Text('Gorde'),
                    )

                  )
              ]
            )
        )],
      )
    );
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