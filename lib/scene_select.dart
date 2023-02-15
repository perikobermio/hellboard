import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'scene_add.dart' as sceneadd;
import 'globals.dart' as globals;

class SceneSelectHome extends StatelessWidget {
  SceneSelectHome();
 
  @override
  Widget build(BuildContext context) {

    bool isConnected() {
      return globals.connBT != null;
    }

    getDetail(grade) {
      List<Widget> items = [];
      const colors = {
        'v': Color.fromARGB(255, 135, 135, 135),
        'v+': Color.fromARGB(255, 135, 135, 135),
        '6a': Color.fromARGB(255, 255, 240, 31),
        '6a+': Color.fromARGB(255, 255, 240, 31),
        '6b': Color.fromARGB(255, 109, 255, 76),
        '6b+': Color.fromARGB(255, 109, 255, 76),
        '6c': Color.fromARGB(255, 91, 225, 255),
        '6c+': Color.fromARGB(255, 91, 225, 255),
        '7a': Color.fromARGB(255, 255, 149, 1),
        '7a+': Color.fromARGB(255, 255, 149, 1),
        '7b': Color.fromARGB(255, 197, 105, 255),
        '7b+': Color.fromARGB(255, 197, 105, 255),
        '7c': Color.fromARGB(255, 252, 64, 64),
        '7c+': Color.fromARGB(255, 252, 64, 64),
        '8a': Color.fromARGB(255, 50, 50, 50),
        '8a+': Color.fromARGB(255, 50, 50, 50),
        '8b': Color.fromARGB(255, 0, 0, 0),
        '8b+': Color.fromARGB(255, 0, 0, 0),
        '8c': Color.fromARGB(255, 0, 0, 0),
        '8c+': Color.fromARGB(255, 0, 0, 0),
      };

      grade.forEach((via) => {
          items.add(
            ListTile( 
              leading: Text(via['grade'], style: TextStyle(fontSize: 18, color: colors[via['grade']])),
              title: Text(via['name']),
              subtitle: Text(via['owner']),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edite',
                onPressed: () {
                  print('GOTO: ADD');
                  print(via);
                  globals.newBloc = via;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sceneadd.SceneAdd()),
                  );
                },
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
      });

      return items;
    }

    getGrade(vias) {
      List<Widget> items = [];

      vias.forEach((k, g) => {
          items.add(
            ExpansionTile(
              title: Text(k.toUpperCase()),
              children: getDetail(g)
            )
          )
      });

      return items;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Bloke barrije',
              onPressed: () {
                globals.clearNewBloc();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sceneadd.SceneAdd()),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: isConnected() ? const Icon(Icons.bluetooth) : const Icon(Icons.bluetooth_disabled),
              tooltip: 'Konekzinue',
              onPressed: () {
                print('BT: trying to connect');
              },
            ),
          ),
        ]
      ),
      body: Container(
          color: Colors.white,
          child: ListView(
            children: getGrade(globals.vias)
        )
      
      )
    );
  }
}