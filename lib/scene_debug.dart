import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:math';
import 'scene_select.dart' as sceneselect;
import 'globals.dart' as globals;
class SceneDebug extends StatefulWidget {
  final String  panel;
  SceneDebug({required this.panel});

  @override
  State<SceneDebug> createState() => _SceneDebug();
}

class _SceneDebug extends State<SceneDebug> {
  List<Map>     _points       = [];
  Map           currentCoords = {'x': 0, 'y': 0, 'w': 0, 'h': 0, 'rx': 0, 'ry': 0, 'led': '---'};
  Map           currentRecord = {'w': 15, 'h': 15};
  int           currentIndex  = -1;

  @override
  Widget build(BuildContext context) {
    _points = setPoints(widget.panel);

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
              fa.set(widget.panel, globals.panels[widget.panel]);

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
                  globals.panels[widget.panel].removeAt(currentIndex);
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
              if(validate(currentCoords['led'], widget.panel)) {
                if(isNew(currentCoords['led'], widget.panel)) {
                  globals.panels[widget.panel].add(currentCoords);
                } else {
                  globals.panels[widget.panel][currentIndex] = currentCoords;
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

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child:
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'C-W',
                    ),
                    style:TextStyle(fontSize:10),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController()..text = currentRecord['w']!.toString(),
                    onSubmitted: (val) {
                      setState(() {
                        currentRecord['w'] = int.tryParse(val);
                      });
                    },
                  )
              ),
              Expanded(
                child:
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'C-H',
                    ),
                    style:TextStyle(fontSize:10),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController()..text = currentRecord['h']!.toString(),
                    onSubmitted: (val) {
                      setState(() {
                        currentRecord['h'] = int.tryParse(val);
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
              maxScale: 10,
              child: GestureDetector(
                onTapUp: (TapUpDetails details) {
                  RenderBox box = context.findRenderObject() as RenderBox;
                  Offset global = box.localToGlobal(details.localPosition);
                  currentCoords = getRealCoords(global, widget.panel, currentRecord);
                  currentIndex  = getCoordsIndex(currentCoords, widget.panel);

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
                    Image.asset('assets/img/${widget.panel}.jpg'),
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
                    if(isNew(currentCoords['led'], widget.panel))
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

Map getRealCoords(coords, panel, currentRecord) {
  Map ret = {'x': coords.dx.toInt() - 7, 'y': coords.dy.toInt() - 7, 'w': currentRecord['w'], 'h': currentRecord['h'], 'rx': coords.dx.toInt(), 'ry': coords.dy.toInt(), 'led': '---'};
  List<dynamic> point =  globals.panels[panel].where((i) => i['x'] < coords.dx && coords.dx < i['x'] + i['w'] && i['y'] < coords.dy && coords.dy < i['y'] + i['h']).toList();
  if(point.isNotEmpty) {
    ret = point[0];
  } else {
    ret['led'] = getNextLed(panel);
  }

  return ret;
}

String getNextLed(panel) {
  if(globals.panels[panel].isEmpty) {
    return '000';
  }

  List<int> leds = [];

  for(var item in globals.panels[panel]) {
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

int getCoordsIndex(coords, panel) {
  return globals.panels[panel].indexWhere((i) => i['led'] == coords['led'] );
}

bool isNew(led, panel) {
  return (globals.panels[panel].where((i) => i['led'] == led).toList().isEmpty);
}

bool validate(led, panel) {
  return (
    globals.panels[panel].where((i) => i['led'] == led).toList().isEmpty && led != '' && led != '---'
  );
}

List<Map> setPoints(panel) {
  List<Map>     p     = [];
  List<dynamic> point = [];

  point = globals.panels[panel].toList();
  for(var item in point) {
    p.add(item);
  }

  return p;
}