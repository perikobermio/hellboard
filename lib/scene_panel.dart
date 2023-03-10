import 'package:flutter/material.dart';
import 'dart:core';
import 'scene_add.dart' as sceneadd;
import 'globals.dart' as globals;
//import 'scene_add.dart' as scenepanel;

class ScenePanel extends StatefulWidget {
  final bool edit;
  final bool? view;
  ScenePanel({required this.edit, this.view});

  @override
  State<ScenePanel> createState() => _ScenePanel();
}

class _ScenePanel extends State<ScenePanel> {
  List<Map>     _points   = [];
  bool          calculate = true;

  @override
  Widget build(BuildContext context) {
    if(calculate && globals.newBloc['value'] != '') {
      _points = setPoints();
    }

    return Scaffold(
      appBar: AppBar(
        title: (widget.edit == true)? Text(globals.newBloc['name']) : Text('Hellboard 40ko panela'),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if(widget.view != true)
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
          if(widget.view != true)
            SizedBox(width: 10),
          if(widget.view != true)
            FloatingActionButton(
              onPressed: () {
                List aValue = [];

                for(var i=0;i<_points.length;i++) {
                    aValue.add(_points[i]['led']);
                }

                globals.newBloc['value'] = aValue.join('-');

                Navigator.push(context, MaterialPageRoute(builder: (context) => sceneadd.SceneAdd(edit: widget.edit)));
              },
              backgroundColor: Color.fromARGB(255, 65, 154, 226),
              heroTag: null,
              child: const Icon(Icons.save),
            )          
        ]
      ),
      body: SizedBox(
        width: 360,
        height: 740,
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(5.0),
          minScale: 0.2,
          maxScale: 4,
          child: GestureDetector(
            onTapUp: (TapUpDetails details) {
              if(widget.view != true) {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset global = box.localToGlobal(details.localPosition);
                Map coords    = getRealCoords(global);
                int index     = _points.indexWhere((i) => i['led'] == coords['led']);

                setState(() {
                  if(coords['x'] != 0) {
                    if(index == -1) {
                      calculate = false;
                      _points.add(coords);
                    } else {
                      _points.removeAt(index);
                    }
                  }
                });
              }
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
                        color:Color.fromARGB(255, 86, 240, 43),
                        width: 1.0
                      ),
                    ),
                  ),
                  )
                )
              ]
            )
          ),
        )

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

List<Map> setPoints() {
  List<Map>     p     = [];
  List<dynamic> point = [];

  for(var led in globals.newBloc['value'].split('-') ) {
    point = globals.panel40.where((i) => i['led'] == led).toList();
    if(point.isNotEmpty) {
      p.add(point[0]);
    }
  }

  return p;
}