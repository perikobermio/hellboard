import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:core';
import 'config.dart' as config;
import 'globals.dart' as globals;
import 'scene_select.dart' as sceneselect;
import 'scene_panel.dart' as scenepanel;
import 'package:firebase_database/firebase_database.dart';


class SceneAdd extends StatefulWidget {
  final bool edit;
  SceneAdd({required this.edit});

  @override
  State<SceneAdd> createState() => _SceneAdd();
}

class _SceneAdd extends State<SceneAdd> {
  final GlobalKey<FormState> formKey = GlobalKey();

  String oldGrade = globals.newBloc['grade'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard geitxu Blokie'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Hasikerara',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sceneselect.SceneSelectHome()),
                );
              },
            ),
          )
        ]
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
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => scenepanel.ScenePanel(edit: widget.edit)),
                      );
                    },
                    icon: Icon(Icons.sports_score),
                    label: Text((globals.newBloc['value'] != '')? globals.newBloc['value'] : 'Aukeratu Blokie'),
                  )
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: SelectFormField(
                    type: SelectFormFieldType.dropdown, // or can be dialog
                    initialValue: globals.newBloc['grade']!,
                    icon: Icon(Icons.grade),
                    labelText: 'Gradue',
                    items: config.grades,
                    onChanged: (val) => globals.newBloc['grade'] = val,
                    onSaved: (val) => globals.newBloc['grade'] = val!
                  )
                ),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Izena',
                    ),
                    controller: TextEditingController()..text = globals.newBloc['name']!,
                    onChanged: (val) {
                      globals.newBloc['name'] = val;
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
                    controller: TextEditingController()..text = globals.newBloc['description']!,
                    onChanged: (val) {
                      globals.newBloc['description'] = val;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if(widget.edit) ...[
                        OutlinedButton(
                          onPressed: () {
                            String grade = getGrade(globals.newBloc['grade']);

                            deleteVia(grade);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => sceneselect.SceneSelectHome()),
                            );
                          },
                          child: const Text('Ezabatu'),
                        )
                      ],
                      ElevatedButton(
                        onPressed: () {
                          String grade = getGrade(globals.newBloc['grade']);

                          if(widget.edit) {
                            oldGrade = getGrade(oldGrade);
                            updateVia(grade, oldGrade);
                          } else {
                            globals.newBloc['owner']  = globals.userfile['user'];
                            globals.newBloc['id']     = DateTime.now().millisecondsSinceEpoch.toString();
                            insertVia(grade);
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => sceneselect.SceneSelectHome()),
                          );

                        },
                        child: const Text('Gorde'),
                      )
                    ]
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

Future<void> insertVia(grade) async {
  int key                   = 0;
  Map<String, Map> updates  = {};

  if(!globals.vias.containsKey(grade)) { //ezpadauen gradue
    updates[grade] = {};
    updates[grade]?[key.toString()]   = globals.newBloc;

    FirebaseDatabase.instance.ref('/vias/').update(updates);
    globals.vias[grade] = [];
    globals.vias[grade].add(globals.newBloc);
  } else { //gradue badauen
    key = globals.vias[grade].length;
    updates[key.toString()]   = globals.newBloc;
  
    FirebaseDatabase.instance.ref('/vias/$grade/').update(updates);
    globals.vias[grade].add(globals.newBloc);
  }
}

Future<void> updateVia(grade, oldGrade) async {
  if(oldGrade == grade) {
    int index = globals.vias[grade].indexWhere((i) => i['id'] == globals.newBloc['id']);
    globals.vias[grade][index] = globals.newBloc;

    DatabaseReference ref = FirebaseDatabase.instance.ref("vias/$grade/$index");
    await ref.set(globals.newBloc);
  } else {
    int index = globals.vias[oldGrade].indexWhere((i) => i['id'] == globals.newBloc['id']);
    globals.vias[oldGrade].removeAt(index);
    DatabaseReference ref = FirebaseDatabase.instance.ref("vias/$oldGrade");
    await ref.set(globals.vias[oldGrade]);
    insertVia(grade);
  }
}
Future<void> deleteVia(grade) async {
  int index = globals.vias[grade].indexWhere((i) => i['id'] == globals.newBloc['id']);
  globals.vias[grade].removeAt(index);
  DatabaseReference ref = FirebaseDatabase.instance.ref("vias/$grade");
  await ref.set(globals.vias[grade]);
}