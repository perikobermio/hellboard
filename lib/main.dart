import 'package:flutter/material.dart';
 
void main() {
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hellboard APP',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const MyHomePage(),
    );
  }
}
 
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
 
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
                    children: <Widget>[
                        ListTile(
                          leading: Text("V+", style: TextStyle(fontSize: 18, color: Colors.black)),
                          title: Text("Erreztxu bet danontzako"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("V+", style: TextStyle(fontSize: 18, color: Colors.black)),
                          title: Text("Benetako kinto masa"),
                          subtitle: Text("Erik"),
                        ),
                    ],
                ),
                ExpansionTile(
                    title: Text("6 gradue (Hasi entrenaten)"),
                    children: <Widget>[
                        ListTile(
                          leading: Text("6a", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 243, 74))),
                          title: Text("Erreztxu bet danontzako"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("6a+", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 237, 213, 0))),
                          title: Text("Erreztxu bet danontzako"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("6b", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 109, 255, 76))),
                          title: Text("Benetako kinto masa"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("6b+", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 1, 127, 20))),
                          title: Text("Benetako kinto masa"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("6c", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 91, 225, 255))),
                          title: Text("Benetako kinto masa"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("6c+", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 200, 255))),
                          title: Text("Benetako kinto masa"),
                          subtitle: Text("Erik"),
                        ),
                    ],
                ),
                ExpansionTile(
                    title: Text("7 gradue (Mas fuerte que el vinagre)"),
                    children: <Widget>[
                        ListTile(
                          leading: Text("7a", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 190, 91))),
                          title: Text("Erreztxu bet danontzako"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("7a+", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 255, 149, 1))),
                          title: Text("Erreztxu bet danontzako"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("7b", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 197, 105, 255))),
                          title: Text("Benetako kinto masa"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("7b+", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 235, 11, 255))),
                          title: Text("Benetako kinto masa"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("7c", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 252, 64, 64))),
                          title: Text("Benetako kinto masa"),
                          subtitle: Text("Erik"),
                        ),
                        ListTile(
                          leading: Text("7c+", style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 156, 0, 0))),
                          title: Text("Benetako kinto masa"),
                          subtitle: Text("Erik"),
                        ),
                    ],
                ),
               
            ],
        )
      
      )
    );
  }


}