import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'scene_add.dart' as sceneadd;
import 'scene_user.dart' as sceneuser;
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
                        globals.newBloc = via;
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
              title: Text(k.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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


class ViaActions {

  Future<void> setDone(via, user) async {
    globals.FireActions fa = globals.FireActions();

    String userid = user['user'];
    String viaid  = via['id'].toString();

    bool toggle = await fa.toggle("users/$userid/vias/$viaid");

    if(toggle == true) {
      globals.userfile['vias'][viaid] = true;
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