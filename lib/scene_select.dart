import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';
import 'scene_panel.dart' as scenepanel;
import 'scene_add.dart' as sceneadd;
import 'scene_user.dart' as sceneuser;
import 'scene_admin.dart' as sceneadmin;
import 'scene_ranking.dart' as sceneranking;
import 'scene_messages.dart' as scenemessages;
import 'globals.dart' as globals;
import 'config.dart' as config;
import 'package:badges/badges.dart' as badges;
class SceneSelectHome extends StatefulWidget {
  SceneSelectHome();

  @override
  State<SceneSelectHome> createState() => _SceneSelectHome();
}
class _SceneSelectHome extends State<SceneSelectHome> {
  _SceneSelectHome();

  @override
  void initState() {
    super.initState();
    globals.loadMessages().then((_) => setState(() {}));
  }
 
  @override
  Widget build(BuildContext context) {
    ViaActions vActions = ViaActions();

    bool isConnected() {
      return globals.connBT != null;
    }

    double getRate(id) {
      double ret = 0;

      if(globals.userViasRate()[id] != null) {
        ret = globals.userViasRate()[id].toDouble();
      }

      return ret;
    }

    Future<void> viaAction(action, via) async {
      if(action == 'done') {
        await vActions.setDone(via, globals.userfile);
      }
    }

    globals.orderVias();

    getDetail(grade) {
      List<Widget> items = [];
    
      grade.forEach((id, via) => {
          items.add(
            ListTile( 
              leading: Text(via['grade'], style: TextStyle(fontSize: 18, color: config.colors[via['grade']])),
              title: Text(via['name']),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: const Icon(Icons.star),
                    iconSize: 15,
                    color: getRateColor(via['rating']),
                    onPressed: () {
                      print('rate');
                    }
                  ),
                  SizedBox(
                    width: 25,
                    child: Text((via['rating'] != 0)? via['rating'].toString() : '--', style: TextStyle(fontSize: 13 ))
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text('|', style: TextStyle(fontSize: 13 ))
                  ),
                  Text(globals.users[via['owner']]['label'])
                ]
              ),
              trailing: Wrap(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.done),
                    tooltip: 'Inje',
                    color: (globals.userfile['vias'].keys.contains(via['id']))? Color.fromARGB(255, 53, 148, 212) : Color.fromARGB(255, 206, 206, 206),
                    onPressed: () {
                      viaAction('done', via).then((a) => setState(() {
                        print('Via DONE click');
                      }));
                    }
                  ),
                  PopupMenuButton(
                    padding: EdgeInsets.zero,
                    onSelected: (item) {
                      if(item == 'edit') {
                        globals.newBloc = Map.from(via);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => sceneadd.SceneAdd(edit: true)));
                      } else if(item == 'show_user_vies') {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => sceneuser.SceneUser(user: via['owner'], section: 1)));
                        });
                      } else if(item == 'show_user_done') {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => sceneuser.SceneUser(user: via['owner'], section: 2)));
                        });
                      } else if(item == 'delete') {
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
                                              globals.FireActions fa  = globals.FireActions();
                                              String grade            = globals.getGrade(via['grade']);
                                              String viaId            = via['id'];

                                              fa.delete('blocs/$grade/$viaId').then((a) => setState(() {
                                                globals.vias[grade].remove(viaId);
                                                globals.cleanBloc(viaId);
                                                Navigator.pop(context);
                                              }));
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
                      } else if(item == 'rate_vie') {

                        double sliderValue = getRate(via['id']);

                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {

                            return StatefulBuilder(
                              builder: (BuildContext context, localSetState) => Container(
                                height: 200,
                                color: Color.fromARGB(255, 25, 123, 64),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.star, color: Color.fromARGB(255, 255, 225, 1), size: 24.0, semanticLabel: 'Puntuazinue'),
                                          Text(sliderValue.toInt().toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        ]
                                      ),
                                      const Text('Ze puntuazio merezi dau blokiek?'),
                                      Slider(
                                        value: sliderValue,
                                        max: 100,
                                        divisions: 20,
                                        label: sliderValue.toInt().toString(),
                                        onChanged: (double value) {
                                          localSetState(() {
                                            sliderValue = value;
                                          });
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            child: const Text('Atzera'),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            child: const Text('Gorde'),
                                            onPressed: () {
                                              globals.FireActions fa = globals.FireActions();

                                              String user   = globals.userfile['user'];
                                              String viaId  = via['id'];
                                              
                                              globals.userViasRate()[viaId] = sliderValue;
                                              fa.set('users/$user/rating/$viaId', sliderValue);

                                              String grade   = globals.getGrade(via['grade']);
                                              double overall = getOverallRate(via['id']);
                                              
                                              fa.set('blocs/$grade/$viaId/rating/', overall.toInt());

                                              setState(() {
                                                globals.vias[grade][via['id']]['rating'] = overall.toInt();
                                                Navigator.pop(context);
                                              });
                                            }
                                          )
                                        ]
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            );
                          },
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return config.viaTools.map((item) {
                        return  PopupMenuItem<String>(
                          value: item['id'],
                          child: Text(item['label']),
                        );
                      }).toList();
                    },
                  )
                ],
              ),
              onTap: () {
                if(isConnected()) {
                  print('LOAD: BLOC');
                  String viavalue = via["value"];
                  String pitch = 'load:$viavalue';
                  
                  Uint8List uint8list = Uint8List.fromList(pitch.codeUnits);
                  globals.connBT?.output.add(uint8list);
                } else {
                  globals.newBloc = via;
                  Navigator.push(context,MaterialPageRoute(builder: (context) => scenepanel.ScenePanel(panel: via["panel"], edit: false, view: true)));
                }
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
              title: Text(k.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              children: getDetail(g)
            )
          )
      });

      return items;
    }

    Widget getMessagesIcon() {
      int done    = (globals.messages.containsKey('done'))?   globals.messages['done'].values.where((i) => i['status'] == 1).toList().length : 0;
      int create  = (globals.messages.containsKey('create'))? globals.messages['create'].values.where((i) => i['status'] == 1).toList().length : 0;
      int modify  = (globals.messages.containsKey('modify'))? globals.messages['modify'].values.where((i) => i['status'] == 1).toList().length : 0;
      int num     = done + create + modify;

      if(num == 0) {
        return Icon(Icons.sms);
      } else {
        return badges.Badge(
          badgeContent: Text(num.toString(), style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)) ),
          child: Icon(Icons.sms),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          if(globals.userfile['user'] == 'erik') 
            Padding(
              padding: EdgeInsets.only(right: 1.0),
              child: IconButton(
                icon: const Icon(Icons.adb),
                tooltip: 'Admin',
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => sceneadmin.SceneAdmin()));
                },
              )
            ),
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: isConnected() ? const Icon(Icons.bluetooth) : const Icon(Icons.bluetooth_disabled),
              tooltip: 'Konekzinue',
              onPressed: () {
                setState(() {
                  connectBT().then((snackBar) => {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar)
                  });
                });
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
      
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: 'Shameboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 60.0),
            label: 'Blokie sortu'
          ),
          BottomNavigationBarItem(
            icon: getMessagesIcon(),
            label: 'Mezuek'
          ),
        ],
        selectedItemColor: Color.fromARGB(255, 94, 94, 94),
        currentIndex: 1,
        onTap: (int index) {
          if(index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => sceneranking.SceneRanking()));
          } else if(index == 1) {
            globals.clearNewBloc();
            Navigator.push(context, MaterialPageRoute(builder: (context) => sceneadd.SceneAdd(edit: false)));
          } else if(index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => scenemessages.SceneMessages()));
          }
        }
      )
    );
  }
}


class ViaActions {

  Future<void> setDone(via, user) async {
    globals.FireActions fa = globals.FireActions();
    globals.Messaging ms = globals.Messaging();

    String userid = user['user'];
    String viaid  = via['id'].toString();

    bool toggle = await fa.toggle("users/$userid/vias/$viaid");

    if(toggle == true) {
      globals.userfile['vias'][viaid] = true;
      ms.done(globals.userfile['user'], via);
    } else {
      globals.userfile['vias'].remove(viaid);
    }
  }

}

Color getRateColor(rate) {
  Color ret = Color.fromARGB(255, 160, 160, 160);

  if(rate > 20 && rate <= 50) {
    ret = Color.fromARGB(255, 3, 143, 190);
  } else if(rate > 50 && rate <= 80) {
    ret = Color.fromARGB(255, 33, 205, 14);
  } else if(rate > 80 && rate <= 90) {
    ret = Color.fromARGB(255, 255, 247, 14);
  } else if(rate > 90 && rate <= 95) {
    ret = Color.fromARGB(255, 255, 123, 0);
  } else if(rate > 95) {
    ret = Color.fromARGB(255, 255, 0, 0);
  }

  return ret;
}

double getOverallRate(id) {
  double  sum     = 0;
  double  users   = 0;

  globals.users.forEach((user, v) {
    if(v['rating'].containsKey(id)) {
      users = users + 1;
      sum   = sum + v['rating'][id];
    }
  });

  return (users == 0)? -1 : sum/users;
}

Future<SnackBar> connectBT() async {
  int ret     = await _connectBT();
  String str  = 'HELLBOARD';

  if(ret == 1) {
    str = 'HELLBOARD-era konekta zara';
  } else if(ret == 2) {
    str = 'ERROR: Seguru zauz HELLBOARD-a konektata dauela?';
  } else if(ret == 3) {
    str = 'HELLBOARD deskonektata';
  }

  final snackBar = SnackBar(
    content: Text(str),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {}
    )
  );

  return snackBar;
}

Future<int> _connectBT() async {
  int ret = 0;
  if(globals.connBT == null) {
    await BluetoothConnection.toAddress(config.btAddress).then((conn) {
      globals.connBT = conn;
      ret = 1;
    }).catchError((e) {
      ret = 2;
    });
  } else {
    await globals.connBT?.close();
    globals.connBT = null;
    ret = 3;
  }
  return ret;
}