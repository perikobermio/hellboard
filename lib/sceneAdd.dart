import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'config.dart' as config;

class SceneAdd extends StatelessWidget {
  const SceneAdd({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard geitxu Blokie'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: SelectFormField(
              type: SelectFormFieldType.dropdown, // or can be dialog
              initialValue: 'v+',
              icon: Icon(Icons.grade),
              labelText: 'Gradue',
              items: config.grades,
              onChanged: (val) => print(val),
              onSaved: (val) => print(val),
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Blokie',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Izena',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Deskribapena',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: SelectFormField(
              type: SelectFormFieldType.dropdown, // or can be dialog
              initialValue: '-',
              icon: Icon(Icons.person),
              labelText: 'Egilea',
              items: config.users,
              onChanged: (val) => print(val),
              onSaved: (val) => print(val),
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(120, 68),
                padding: EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
              onPressed: () { },
              child: Text('Gorde'),
            )

          ),


        ],
      )
    );
  }
}