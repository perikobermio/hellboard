import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:core';
import 'config.dart' as config;
import 'globals.dart' as globals;
//import 'scene_add.dart' as scenepanel;

class ScenePanel extends StatefulWidget {
  ScenePanel();

  @override
  State<ScenePanel> createState() => _ScenePanel();
}

class _ScenePanel extends State<ScenePanel> {
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard gure panela'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
              children: <Widget>[
                Image.asset('assets/img/panel40.png'),
                Positioned(
                  left: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      print('bat');
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 100,
                  child: InkWell(
                    onTap: () {
                      print('bi');
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: 100,
                      height: 100,
                    ),
                  ),
                )
              ]
          )
        ],
      )
    );
  }
}