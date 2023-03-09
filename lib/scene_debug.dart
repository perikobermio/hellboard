import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:math';
import 'scene_select.dart' as sceneselect;
import 'globals.dart' as globals;


const Map sizes = {
  'xs':   {'w': 15, 'y': 15},
  's':    {'w': 18, 'y': 18},
  'm':    {'w': 22, 'y': 22},
  'l':    {'w': 25, 'y': 25},
  'xl':   {'w': 30, 'y': 30}
};
Map currentSize = sizes['xs'];
class SceneDebug extends StatefulWidget {
  SceneDebug();

  @override
  State<SceneDebug> createState() => _SceneDebug();
}

class _SceneDebug extends State<SceneDebug> {
  List<Map>     _points       = [];
  Map           currentCoords = {'x': 0, 'y': 0, 'w': 0, 'h': 0, 'rx': 0, 'ry': 0, 'led': '---'};
  int           currentIndex  = -1;

  @override
  Widget build(BuildContext context) {
    _points = setPoints();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard 40ko panela'),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              globals.FireActions fa  = globals.FireActions();
              fa.set('panel40', globals.panel40);

              Navigator.push(context,MaterialPageRoute(builder: (context) => sceneselect.SceneSelectHome()));
            },
            backgroundColor: Color.fromARGB(255, 65, 154, 226),
            heroTag: null,
            child: const Icon(Icons.save),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                if(currentIndex != -1) {
                  globals.panel40.removeAt(currentIndex);
                }
                currentCoords = {'x': 0, 'y': 0, 'w': 0, 'h': 0, 'rx': 0, 'ry': 0, 'led': '---'};
              });
            },
            backgroundColor: Color.fromARGB(255, 16, 214, 19),
            heroTag: null,
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: () {
              if(validate(currentCoords['led'])) {
                if(isNew(currentCoords['led'])) {
                  globals.panel40.add(currentCoords);
                } else {
                  globals.panel40[currentIndex] = currentCoords;
                }
              } else {
                print('NO VALIDATE');
              }
              setState(() {
                currentCoords = {'x': 0, 'y': 0, 'w': 0, 'h': 0, 'rx': 0, 'ry': 0, 'led': '---'};
              });
            },
            backgroundColor: Color.fromARGB(255, 222, 234, 243),
            heroTag: null,
            child: const Icon(Icons.add),
          )          
        ]
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child:
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'X-px',
                    ),
                    style:TextStyle(fontSize:10),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController()..text = currentCoords['x']!.toString(),
                    onSubmitted: (val) {
                      setState(() {
                        currentCoords['x'] = int.tryParse(val) ?? 0;
                      });
                    },
                  )
              ),
              Expanded(
                child:
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Y-px',
                    ),
                    style:TextStyle(fontSize:10),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController()..text = currentCoords['y']!.toString(),
                    onSubmitted: (val) {
                      setState(() {
                        currentCoords['y'] = int.tryParse(val) ?? 0;
                      });
                    },
                  )
              ),
              Expanded(
                child:
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'W-px',
                    ),
                    style:TextStyle(fontSize:10),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController()..text = currentCoords['w']!.toString(),
                    onSubmitted: (val) {
                      setState(() {
                        currentCoords['w'] = int.tryParse(val) ?? 0;
                      });
                    },
                  )
              ),
              Expanded(
                child:
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'H-px',
                    ),
                    style:TextStyle(fontSize:10),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController()..text = currentCoords['h']!.toString(),
                    onSubmitted: (val) {
                      setState(() {
                        currentCoords['h'] = int.tryParse(val) ?? 0;
                      });
                    },
                  )
              ),
              Expanded(
                child:
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'RX-px',
                    ),
                    style:TextStyle(fontSize:10),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController()..text = currentCoords['rx']!.toString(),
                    onSubmitted: (val) {
                      setState(() {
                        currentCoords['rx'] = int.tryParse(val) ?? 0;
                      });
                    },
                  )
              ),
              Expanded(
                child:
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'RY-px',
                    ),
                    style:TextStyle(fontSize:10),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController()..text = currentCoords['ry']!.toString(),
                    onSubmitted: (val) {
                      setState(() {
                        currentCoords['ry'] = int.tryParse(val) ?? 0;
                      });
                    },
                  )
              ),
              Expanded(
                child:
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'LED',
                    ),
                    style:TextStyle(fontSize:10),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController()..text = currentCoords['led']!.toString(),
                    onSubmitted: (val) {
                      setState(() {
                        currentCoords['led'] = val;
                      });
                    },
                  )
              )
            ]
          ),
          SizedBox(
            width: 360,
            height: 740,
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(5.0),
              minScale: 0.2,
              maxScale: 4,
              child: GestureDetector(
                onTapUp: (TapUpDetails details) {
                  RenderBox box = context.findRenderObject() as RenderBox;
                  Offset global = box.localToGlobal(details.localPosition);
                  currentCoords = getRealCoords(global);
                  currentIndex  = getCoordsIndex(currentCoords);

                  setState(() {
                    if(currentIndex == -1) {
                      print('NEW');
                    } else {
                      print('EDIT');
                    }
                  });
                },
                child: Stack(
                  children: [
                    Image.asset('assets/img/panel40.png'),
                    ..._points.map((point) => Positioned(
                      left: point['x'].toDouble(),
                      top:  point['y'].toDouble(),
                      child: Container(
                        width: point['w'].toDouble(),
                        height: point['h'].toDouble(),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: (point['led'] == currentCoords['led'])? Color.fromARGB(255, 255, 0, 0) : Color.fromARGB(255, 86, 240, 43),
                            width: (point['led'] == currentCoords['led'])? 1.7 : 1
                          ),
                        ),
                      ),
                      ),
                    ),
                    ..._points.map((point) => Positioned(
                      left: point['rx'].toDouble(),
                      top: point['ry'].toDouble(),
                      child: Text(point['led'], style: TextStyle(fontSize: 6, color: (point['led'] == currentCoords['led'])? Color.fromARGB(255, 255, 0, 0) : Color.fromARGB(255, 86, 240, 43))),
                      ),
                    ),
                    if(isNew(currentCoords['led']))
                      Positioned(
                        left: currentCoords['x']?.toDouble(),
                        top: currentCoords['y']?.toDouble(),
                        child: Container(
                          width: currentCoords['w'].toDouble(),
                          height: currentCoords['h'].toDouble(),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Color.fromARGB(255, 7, 123, 255),
                              width: 1.7
                            ),
                          ),
                        ),
                      )
                    ]
                  )
                ),
              )
          )
        ]
      )
    );
  }
}

Map getRealCoords(coords) {
  Map ret = {'x': coords.dx.toInt() - 7, 'y': coords.dy.toInt() - 7, 'w': 15, 'h': 15, 'rx': coords.dx.toInt(), 'ry': coords.dy.toInt(), 'led': '---'};
  List<dynamic> point =  globals.panel40.where((i) => i['x'] < coords.dx && coords.dx < i['x'] + i['w'] && i['y'] < coords.dy && coords.dy < i['y'] + i['h']).toList();
  if(point.isNotEmpty) {
    ret = point[0];
  } else {
    ret['led'] = getNextLed();
  }

  return ret;
}

String getNextLed() {
  List<int> leds = [];

  for(var item in globals.panel40) {
    leds.add(int.tryParse(item['led']) ?? 0);
  }

  int lastLed     = leds.reduce(max);
  int currentLed  = lastLed + 1;

  while (currentLed.toString().contains('8') || currentLed.toString().contains('9')) {
    currentLed++;
  }

  String rets = currentLed.toString();

  if(currentLed.bitLength == 4) {
    return '0$rets';
  } else if(currentLed.bitLength < 4) {
    return '00$rets';
  }
  return rets;
}

int getCoordsIndex(coords) {
  return globals.panel40.indexWhere((i) => i['led'] == coords['led'] );
}

bool isNew(led) {
  return (globals.panel40.where((i) => i['led'] == led).toList().isEmpty);
}

bool validate(led) {
  return (
    globals.panel40.where((i) => i['led'] == led).toList().isEmpty &&
    led != '' && led != '---' && led.length == 3
  );
}

List<Map> setPoints() {
  List<Map>     p     = [];
  List<dynamic> point = [];

  point = globals.panel40.toList();
  for(var item in point) {
    p.add(item);
  }

  return p;
}