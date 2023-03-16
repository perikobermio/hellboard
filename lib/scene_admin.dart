import 'package:flutter/material.dart';
import 'scene_debug.dart' as scenedebug;
import 'dart:core';
import 'config.dart' as config;

class SceneAdmin extends StatefulWidget {
  SceneAdmin();

  @override
  State<SceneAdmin> createState() => _SceneAdmin();
}

class _SceneAdmin extends State<SceneAdmin> {
  _SceneAdmin();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN'),
      ),
      body: Column(
        children: [
          Text('Panelak edite', style: TextStyle(fontSize: 18)),
          
          for(var panel in config.panels)
            ListTile( 
              title: Text(panel['label']),
              trailing: Wrap(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => scenedebug.SceneDebug(panel: panel['value'])));
                    }
                  ),
                ]
              )
            ),
        ]
      )
    );
  }
}