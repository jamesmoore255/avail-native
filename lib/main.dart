import "package:avail/pages/depiction-page.dart";
import "package:avail/pages/home-page.dart";
import "package:avail/pages/script-page.dart";
import "package:avail/pages/sound-page.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Avail",
      theme: ThemeData(
        primaryColor: Color(0xFFEEEEEE),
        fontFamily: "Montserrat",
        backgroundColor: Color(0xFFFAFAFA),
      ),
      routes: {
        "/": (context) => HomePage(),
        "/sound": (context) => SoundPage(),
        "/depiction": (context) => DepictionPage(),
        "/script": (context) => ScriptPage(),
      },
    );
  }
}
