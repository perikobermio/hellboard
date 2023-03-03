import 'package:flutter/material.dart';
import 'dart:core';
import 'globals.dart' as globals;
import 'config.dart' as config;
import 'dart:typed_data';

class SceneUser extends StatefulWidget {
  final int section;
  final String user;
  
  SceneUser({required this.user, required this.section});

  @override
  State<SceneUser> createState() => _SceneUser();
}

class _SceneUser extends State<SceneUser> {

  getViasRow() {
    List<Widget> items = [];

    globals.vias.forEach((k, g) => {
      for(var via in g.where((i) => i['owner'] == widget.user)) {
        items.add(
          ListTile( 
              leading: Text(via['grade'], style: TextStyle(fontSize: 18, color: config.colors[via['grade']])),
              title: Text(via['name']),
              subtitle: Text(via['description']),
              onTap: () {
                print('LOAD: BLOC');
                String viavalue = via["value"];
                String pitch = 'load:$viavalue';
                
                Uint8List uint8list = Uint8List.fromList(pitch.codeUnits);
                globals.connBT?.output.add(uint8list);
              }
          )
        )
      }
    });

    return ExpansionTile(
      title: Text('Sortutako bloke danak', style: TextStyle(fontSize: 20)),
      initiallyExpanded: (widget.section == 1)? true : false,
      children: items
    );

  }

  getViasDone() {
    List<Widget> items = [];

    globals.vias.forEach((k, g) => {
      for(var via in g.where((i) => i['owner'] == widget.user)) {
        items.add(
          ListTile( 
              leading: Text(via['grade'], style: TextStyle(fontSize: 18, color: config.colors[via['grade']])),
              title: Text(via['name']),
              subtitle: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(globals.users[via['owner']]['label'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 21, 179, 42) ))
                  ),
                  Text(via['description'])
                ]
              ),
              onTap: () {
                print('LOAD: BLOC');
                String viavalue = via["value"];
                String pitch = 'load:$viavalue';
                
                Uint8List uint8list = Uint8List.fromList(pitch.codeUnits);
                globals.connBT?.output.add(uint8list);
              }
          )
        )
      }
    });

    return ExpansionTile(
      title: Text('Ataratako bloke danak', style: TextStyle(fontSize: 20)),
      initiallyExpanded: (widget.section == 2)? true : false,
      children: items
    );

  }

  @override
  Widget build(BuildContext context) {
    String userLabel = globals.users[widget.user]['label'];

    return Scaffold(
      appBar: AppBar(
        title: Text('$userLabel -n datuek'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            getViasRow(),
            getViasDone(),
          ]
        )
      )
    );
  }
}