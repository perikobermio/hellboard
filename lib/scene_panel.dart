import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:core';
import 'config.dart' as config;
import 'globals.dart' as globals;
//import 'scene_add.dart' as scenepanel;

class ScenePanel extends StatefulWidget {
  ScenePanel();

  @override
  State<ScenePanel> createState() => _ScenePanel();
}

class _ScenePanel extends State<ScenePanel> {
  final GlobalKey<FormState> formKey = GlobalKey();
  List<Map> _points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard gure panela'),
      ),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(5.0),
        minScale: 0.2,
        maxScale: 4,
        child: GestureDetector(
          onTapUp: (TapUpDetails details) {
            RenderBox box = context.findRenderObject() as RenderBox;
            Offset global = box.localToGlobal(details.localPosition);
            Map coords = getRealCoords(global);
            
            //print(global.dx);
            //print(global.dy);

            setState(() {
              if(coords['x'] != 0) {
                print(coords['x']);
                print(coords['y']);
                _points.add(coords);
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
                      color:Color.fromARGB(255, 86, 240, 43),
                      width: 1.0
                    ),
                  ),
                ),
                )
              ),
              ..._points.map((point) => Positioned(
                left: 0,
                top:  0,
                child: Container(
                  width: 1,
                  height: 1,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color:Color.fromARGB(255, 48, 92, 205),
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