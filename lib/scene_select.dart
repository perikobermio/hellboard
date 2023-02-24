import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'scene_add.dart' as sceneadd;
import 'globals.dart' as globals;
import 'config.dart' as config;


class SceneSelectHome extends StatefulWidget {
  SceneSelectHome();

  @override
  State<SceneSelectHome> createState() => _SceneSelectHome();
}
class _SceneSelectHome extends State<SceneSelectHome> {
  _SceneSelectHome();
 
  @override
  Widget build(BuildContext context) {

    bool isConnected() {
      return globals.connBT != null;
    }

    globals.orderVias();

    getToolsMenu() {
      List<PopupMenuItem> ret = [];
      for(var item in config.viaTools) {
        ret.add(PopupMenuItem(
            value: item['id'],
            child: Text(item['label'])
          )
        );
      }
      return ret;
    }
    List<PopupMenuItem> toolsMenu = getToolsMenu();

    getDetail(grade) {
      List<Widget> items = [];
    
      grade.forEach((via) => {
          items.add(
            ListTile( 
              leading: Text(via['grade'], style: TextStyle(fontSize: 18, color: config.colors[via['grade']])),
              title: Text(via['name']),
              subtitle: Text(via['owner']),
              trailing: Wrap(
                children: <Widget>[
                  PopupMenuButton(
                    onSelected: (value) {
                      print(value);
                      print(via);
                      print(globals.userfile);
                    },
                    itemBuilder: (BuildContext bc) {
                      return toolsMenu;
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edite',
                    onPressed: () {
                      globals.newBloc = via;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => sceneadd.SceneAdd(edit: true)),
                      );
                    }
                  )
                ],
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
                  MaterialPageRoute(builder: (context) => sceneadd.SceneAdd(edit: false)),
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