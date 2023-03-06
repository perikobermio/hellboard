import 'package:flutter/material.dart';
import 'dart:core';
import 'scene_select.dart' as sceneselect;
import 'globals.dart' as globals;

class SceneDebug extends StatefulWidget {
  SceneDebug();

  @override
  State<SceneDebug> createState() => _SceneDebug();
}

class _SceneDebug extends State<SceneDebug> {
  List<Map>     _points       = [];
  Map           currentCoords = {};
  int           currentIndex  = 0;

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
              setState(() {
                globals.newBloc['value'] = '';
                _points = [];
              });
            },
            backgroundColor: Color.fromARGB(255, 113, 194, 139),
            heroTag: null,
            child: const Icon(Icons.remove),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              List aValue = [];

              for(var i=0;i<_points.length;i++) {
                  aValue.add(_points[i]['led']);
              }

              globals.newBloc['value'] = aValue.join('-');

              Navigator.push(context,MaterialPageRoute(builder: (context) => sceneselect.SceneSelectHome()),);
            },
            backgroundColor: Color.fromARGB(255, 65, 154, 226),
            heroTag: null,
            child: const Icon(Icons.save),
          )          
        ]
      ),
      body: InteractiveViewer(
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
              if(currentCoords['x'] != 0) {
                print(currentCoords['led']);
                print(currentIndex);
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
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: (point['led'] == currentCoords['led'])? Color.fromARGB(255, 255, 0, 0) : Color.fromARGB(255, 86, 240, 43),
                      width: (point['led'] == currentCoords['led'])? 1.7 : 1
                    ),
                  ),
                ),
                )
              )
            ]
          )
        ),
      )
    );
  }
}

Map getRealCoords(coords) {
  Map ret = {'x': 0};
  List<dynamic> point =  globals.panel40.where((i) => i['x'] < coords.dx && coords.dx < i['x'] + i['w'] && i['y'] < coords.dy && coords.dy < i['y'] + i['h']).toList();
  if(point.isNotEmpty) {
    ret = point[0];
  }

  return ret;
}

int getCoordsIndex(coords) {
  return globals.panel40.indexWhere((i) => i['led'] == coords['led'] );
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