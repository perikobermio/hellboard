import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:http/http.dart' as http;

const btAddress = 'C8:F0:9E:75:16:42';
const viasFile  = 'https://extraordinary-flan-0cf528.netlify.app/vias.json';
 
void main() {
  runApp(const MyApp());
}

Future<Map<String, dynamic>> preLoad() async {
  BluetoothConnection connection  = await BluetoothConnection.toAddress(btAddress);

  final httpPackageUrl            = Uri.parse(viasFile);
  final promiseVias               = await http.read(httpPackageUrl);
  Map<String, dynamic> oVias      = jsonDecode(promiseVias);

  return {
    'connection': connection,
    'vias':       oVias
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: preLoad(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          return MaterialApp(
            title: 'Hellboard APP',
            theme: ThemeData(
              primarySwatch: Colors.lightGreen,
            ),
            home: MyHomePage(
              connection: snapshot.data?['connection'], 
              oVias: snapshot.data?['vias']
            )
          );

        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}

 
class MyHomePage extends StatelessWidget {
  final BluetoothConnection? connection;
  final Map? oVias;
  MyHomePage({required this.connection, required this.oVias});

  _getDetail(o) {
    List<Widget> items = [];
    const colors = {
      'v': Color.fromARGB(255, 135, 135, 135),
      'v+': Color.fromARGB(255, 135, 135, 135),
      '6a': Color.fromARGB(255, 255, 240, 31),
      '6a+': Color.fromARGB(255, 255, 240, 31),
      '6b': Color.fromARGB(255, 109, 255, 76),
      '6b+': Color.fromARGB(255, 109, 255, 76),
      '6c': Color.fromARGB(255, 91, 225, 255),
      '6c+': Color.fromARGB(255, 91, 225, 255),
      '7a': Color.fromARGB(255, 255, 149, 1),
      '7a+': Color.fromARGB(255, 255, 149, 1),
      '7b': Color.fromARGB(255, 197, 105, 255),
      '7b+': Color.fromARGB(255, 197, 105, 255),
      '7c': Color.fromARGB(255, 252, 64, 64),
      '7c+': Color.fromARGB(255, 252, 64, 64),
      '8a': Color.fromARGB(255, 50, 50, 50),
      '8a+': Color.fromARGB(255, 50, 50, 50),
      '8b': Color.fromARGB(255, 0, 0, 0),
      '8b+': Color.fromARGB(255, 0, 0, 0),
      '8c': Color.fromARGB(255, 0, 0, 0),
      '8c+': Color.fromARGB(255, 0, 0, 0),
    };

    o.forEach((via) => 
      items.add(
        ListTile( 
          leading: Text(via['grade'], style: TextStyle(fontSize: 18, color: colors[via['grade']])),
          title: Text(via['name']),
          subtitle: Text(via['owner']),
          trailing: Icon(Icons.info),
          onTap: () {
            String viavalue = via["value"];
            String pitch = 'load:$viavalue';
            
            Uint8List uint8list = Uint8List.fromList(pitch.codeUnits);
            connection?.output.add(uint8list);
            
          }
        )
      )
    );
    return items;
  }
 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Hellboard'),
      ),
      body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
                ExpansionTile(
                    title: Text("V+ (Sako patatas)"),
                    children: _getDetail(oVias?['vias']['v'])
                ),
                ExpansionTile(
                    title: Text("6 gradue (Hasi entrenaten)"),
                    children: _getDetail(oVias?['vias']['vi']),
                ),
                ExpansionTile(
                    title: Text("7 gradue (Mas fuerte que el vinagre)"),
                    children: _getDetail(oVias?['vias']['vii']),
                ),
                ExpansionTile(
                    title: Text("8 (Semidios)"),
                    children: _getDetail(oVias?['vias']['viii']),
                ),
               
            ],
        )
      
      )
    );
  }


}