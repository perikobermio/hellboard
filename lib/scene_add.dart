import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:core';
import 'config.dart' as config;
import 'globals.dart' as globals;
import 'scene_select.dart' as sceneselect;
import 'scene_panel.dart' as scenepanel;

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
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  color: Color.fromARGB(255, 25, 123, 64),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text('Seguru zauz borra guzule?'),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              child: const Text('Ez'),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              child: const Text('Bai'),
                                              onPressed: () {
                                                globals.ViasActions va = globals.ViasActions();
                                                String grade = globals.getGrade(globals.newBloc['grade']);

                                                va.deleteVia(grade, globals.newBloc['id']);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => sceneselect.SceneSelectHome()),
                                                );
                                              }
                                            )
                                          ]
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text('Ezabatu'),
                        )
                      ],
                      ElevatedButton(
                        onPressed: () {
                          globals.ViasActions va = globals.ViasActions();
                          String grade = globals.getGrade(globals.newBloc['grade']);

                          if(widget.edit) {
                            oldGrade = globals.getGrade(oldGrade);
                            va.updateVia(grade, oldGrade);
                          } else {
                            globals.newBloc['owner']  = globals.userfile['user'];
                            globals.newBloc['id']     = DateTime.now().millisecondsSinceEpoch.toString();
                            va.insertVia(grade);
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