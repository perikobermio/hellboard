import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:core';
import 'scene_add.dart' as sceneadd;
import 'globals.dart' as globals;
class ScenePanel extends StatefulWidget {
  final String  panel;
  final bool    edit;
  final bool?   view;
  ScenePanel({required this.edit, required this.panel, this.view});

  @override
  State<ScenePanel> createState() => _ScenePanel();
}

class _ScenePanel extends State<ScenePanel> {
  List<Map>     _points   = [];
  List          _init     = [];
  List          _foots    = [];
  List          _top      = [];
  bool          calculate = true;

  final viewTransformationController = TransformationController();

  @override
  void initState() {
    if(widget.panel == 'panel20') {
      double zoomFactor = 2.0;
      //double xTranslate = 300.0;
      //double yTranslate = 300.0;
      viewTransformationController.value.setEntry(0, 0, zoomFactor);
      viewTransformationController.value.setEntry(1, 1, zoomFactor);
      viewTransformationController.value.setEntry(2, 2, zoomFactor);
      //viewTransformationController.value.setEntry(0, 3, -xTranslate);
      //viewTransformationController.value.setEntry(1, 3, -yTranslate);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(calculate && globals.newBloc['value'] != '') {
      _points = setPoints(widget.panel);
    }
    if(globals.newBloc.containsKey('init')) {
      _init = globals.newBloc['init'].split('-');
    }
    if(globals.newBloc.containsKey('foots')) {
      _foots = globals.newBloc['foots'].split('-');
    }
    if(globals.newBloc.containsKey('top')) {
      _top = globals.newBloc['top'].split('-');
    }

    Color getTypeColor(led) {
      if(_init.contains(led)) {
        return Color.fromARGB(255, 38, 38, 224);
      } else if(_foots.contains(led)) {
        return Color.fromARGB(255, 255, 255, 255);
      } else if(_top.contains(led)) {
        return Color.fromARGB(255, 255, 0, 0);
      } else {
        return Color.fromARGB(255, 55, 255, 0);
      }
    }
    String getPointType(led) {
      if(_init.contains(led)) {
        return 'init';
      } else if(_foots.contains(led)) {
        return 'foots';
      } else if(_top.contains(led)) {
        return 'top';
      } else {
        return '';
      }
    }

    void rotatePoint(led, index) {
      if(_init.contains(led)) {
        _init.remove(led);
        _foots.add(led);
      } else if(_foots.contains(led)) {
        _foots.remove(led);
        _top.add(led);
      } else if(_top.contains(led)) {
        _top.remove(led);
        _points.removeAt(index);
      } else {
        _init.add(led);
      }
    }

    Positioned getPointIcon(point) {
      double size() {
        return (widget.panel == 'panel20')? 5 : 15;
      }
      double sizePadding() {
        return (widget.panel == 'panel20')? 5 : 15;
      }

      Icon getIcon(led) {
        if(_init.contains(led)) {
          return Icon(MdiIcons.handBackLeft, color: getTypeColor(led), size: size());
        } else if(_foots.contains(led)) {
          return Icon(MdiIcons.footPrint, color: getTypeColor(led), size: size());
        } else if(_top.contains(led)) {
          return Icon(MdiIcons.arrowUpDropCircleOutline, color: getTypeColor(led), size: size());
        } else {
          return Icon(Icons.stop);
        }
      }

      return Positioned(
        left: point['x'].toDouble() - sizePadding(),
        top:  point['y'].toDouble(),
        child: getIcon(point['led'])
      );
      
    }

    return Scaffold(
      appBar: AppBar(
        title: (widget.edit == true)? Text(globals.newBloc['name']) : Text('Hellboard ${widget.panel}'),
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
                globals.newBloc['value']  = aValue.join('-');
                globals.newBloc['init']   = _init.join('-');
                globals.newBloc['foots']  = _foots.join('-');
                globals.newBloc['top']    = _top.join('-');

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
          transformationController: viewTransformationController,
          boundaryMargin: const EdgeInsets.all(5.0),
          minScale: 0.2,
          maxScale: 10,
          child: GestureDetector(
            onTapUp: (TapUpDetails details) {
              if(widget.view != true) {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset global = box.localToGlobal(details.localPosition);
                Map coords    = getRealCoords(global, widget.panel);
                int index     = _points.indexWhere((i) => i['led'] == coords['led']);

                setState(() {
                  if(coords['x'] != 0) {
                    if(index == -1) {
                      calculate = false;
                      _points.add(coords);
                    } else {
                      calculate = false;
                      rotatePoint(coords['led'], index);
                    }
                  }
                });
              }
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
                        color: getTypeColor(point['led']),
                        width: 1.0
                      ),
                    ),
                  ),
                  )
                ),
                ..._points.where((point) {
                  String type = getPointType(point['led']);
                  return (type != '');
                }).map((point) => getPointIcon(point))
              ]
            )
          ),
        )

      )
      
    );
  }
}

Map getRealCoords(coords, panel) {
  Map ret = {'x': 0};
  List<dynamic> point = globals.panels[panel].where((i) => i['x'] < coords.dx && coords.dx < i['x'] + i['w'] && i['y'] < coords.dy && coords.dy < i['y'] + i['h']).toList();
  if(point.isNotEmpty) {
    ret = point[0];
  }

  return ret;
}

List<Map> setPoints(panel) {
  List<Map>     p     = [];
  List<dynamic> point = [];

  for(var led in globals.newBloc['value'].split('-') ) {
    point = globals.panels[panel].where((i) => i['led'] == led).toList();
    if(point.isNotEmpty) {
      p.add(point[0]);
    }
  }

  return p;
}