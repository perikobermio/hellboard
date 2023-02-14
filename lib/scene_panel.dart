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
  List<Offset> _points = [];

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
            Offset coords = getRealCoords(global);
            
            print(global.dx);
            print(global.dy);

            setState(() {
              _points.add(coords);
            });
          },
          child: Stack(
            children: [
              Image.asset('assets/img/panel40.png'),
              ..._points.map((point) => Positioned(
                left: point.dx,
                top: point.dy,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 86, 240, 43),
                  ),
                ),
                )
              ),
              ..._points.map((point) => Positioned(
                left: 176,
                top:  29,
                child: Container(
                  width: 18,
                  height: 16,
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
    );
  }
}

Offset getRealCoords(coords) {
  //Offset nCoords = Offset(0, 0);
  
  List<dynamic> a =  globals.panel40.where((i) => 
    i['x'] < coords.dx && coords.dx < i['x'] + i['w'] && i['y'] < coords.dy && coords.dy < i['y'] + i['h']
  ).toList();

  print(coords);
  print(a);

  return coords;
}