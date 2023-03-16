import 'package:flutter/material.dart';
import 'dart:core';
import 'globals.dart' as globals;
import 'scene_select.dart' as sceneselect;

class SceneMessages extends StatefulWidget {  
  SceneMessages();

  @override
  State<SceneMessages> createState() => _SceneMessages();
}

class _SceneMessages extends State<SceneMessages> {

  @override
  Widget build(BuildContext context) {

    Future<void> deleteMsg(msg) async {
      globals.FireActions fa = globals.FireActions();

      fa.delete('messages/${globals.userfile['user']}/${msg['type']}/${msg['id']}');
      globals.messages[msg['type']].removeWhere((key, value) => key == msg['id']);
    }

    Future<void> deleteAllMsg() async {
      globals.FireActions fa = globals.FireActions();

      fa.delete('messages/${globals.userfile['user']}');
      globals.messages = {};
    }
    
    List<Map> getAllMsgs() {
      List<Map> msgs = [];

      globals.messages.forEach((type, items) => {
        items.forEach((taim, v) => {
          msgs.add({'type': type, 'id': taim, 'msg': v['msg'], 'status': v['status']})
        })
      });

      msgs.sort((a, b) => b['id'].compareTo(a['id']));

      return msgs;
    }

    Future<void> setViewed() async {
      globals.FireActions fa = globals.FireActions();

      globals.messages.forEach((type, items) => {
        items.forEach((taim, v) => {
          if(v['status'] == 1) {
            fa.set('messages/${globals.userfile['user']}/$type/$taim/status', 0)
          }
        })
      });
    }

    listWidget() {
      List<Widget>  items   = [];

      Widget getLeading(type) {
        if(type == 'done') {
          return Icon(Icons.done, color: Color.fromARGB(255, 36, 141, 198), size: 30.0);
        } if(type == 'create') {
          return Icon(Icons.add, color: Color.fromARGB(255, 5, 146, 66), size: 25.0);
        } if(type == 'modify') {
          return Icon(Icons.edit, color: Color.fromARGB(255, 191, 162, 73), size: 20.0);
        } else {
          return Icon(Icons.sms, color: Color.fromARGB(255, 0, 0, 0), size: 20.0);
        }
      }

      for(Map msg in getAllMsgs()) {
        items.add(Card(
          color: (msg['status'] == 1)? Color.fromARGB(255, 200, 234, 185) : Color.fromARGB(255, 255, 255, 255),
          child: ListTile( 
            leading: getLeading(msg['type']),
            title: Text(msg['msg'], style: TextStyle(fontStyle: FontStyle.italic)),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 135, 133, 128), size: 20.0),
              tooltip: 'Ezabatu',
              onPressed: () {
                deleteMsg(msg).then((_) => setState(() {}) );
              }
            )
          ))
        );
      }

      return items;
    }

    setViewed();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Atzera',
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => sceneselect.SceneSelectHome()));
              },
            ),
            Text('Mezuek'),
          ]
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Borra danak',
            onPressed: () {
              deleteAllMsg().then((_) => setState(() {}) );
            },
          )
        ]
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: listWidget()
        )
      )
    );
  }
}