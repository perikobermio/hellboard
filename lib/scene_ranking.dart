import 'package:flutter/material.dart';
import 'dart:core';
import 'globals.dart' as globals;

class SceneRanking extends StatefulWidget {  
  SceneRanking();

  @override
  State<SceneRanking> createState() => _SceneRanking();
}

class _SceneRanking extends State<SceneRanking> {

  @override
  Widget build(BuildContext context) {
    const Map<String,int> pts = {
      'V': 1, 'V+': 2, '6a': 4, '6a+': 6, '6b': 10, '6b+': 14, '6c': 20, '6c+': 25, '7a': 35, '7a+': 42, '7b': 52, '7b+': 56, '7c': 70, '7c+': 80, 
      '8a': 110, '8a+': 130, '8b': 170, '8b+': 190, '8c': 240, '8c+': 280, '9a': 350, '9a+': 400, '9b': 500, '9b+': 700, '9c': 1000, '9c+': 2000
    };

    int getPts(user) {
      int res = 0;

      doit(via) {
        for(var grade in globals.vias.values) {
          if(grade.containsKey(via)) {
            res = res + pts[grade[via]['grade']]!;
          }
        }
      } 
      globals.users[user]['vias'].keys.forEach((via) => doit(via));

      return res;
    }
  

    List<Map> getLeaderboard() {
      List<Map> users = [];

      globals.users.forEach((k, v) => {
        users.add({
          'name': v['label'],
          'pts': getPts(k),
        })
      });

      users.sort((a, b) => b["pts"].compareTo(a["pts"]));

      return users;
    }

    listWidget() {
      List<Widget>  items   = [];
      List<Map>     users   = getLeaderboard();
      int           ranking = 1;

      Widget getLeading(type) {
        if(type == 1) {
          return Icon(Icons.military_tech, color: Color.fromARGB(255, 255, 225, 1), size: 30.0);
        } if(type == 2) {
          return Icon(Icons.military_tech, color: Color.fromARGB(255, 184, 187, 190), size: 25.0);
        } if(type == 3) {
          return Icon(Icons.military_tech, color: Color.fromARGB(255, 191, 162, 73), size: 20.0);
        } else {
          return Text('${type.toString()}.');
        }
      }

      for(Map user in users) {
        items.add(ListTile( 
          leading: SizedBox(
            width: 30,
            child: Center(
              child: getLeading(ranking)
            )
          ),
          title: Text(user['name']),
          trailing: Text('${user['pts']} pts'),
          onTap: () {}
        ));
        ranking = ranking + 1;
      }

      return items;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Shame Leaderboard'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: listWidget()
        )
      )
    );
  }
}