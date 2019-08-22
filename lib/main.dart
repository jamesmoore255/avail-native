import 'package:avail/pages/auth-page.dart';
import "package:avail/pages/depiction-page.dart";
import "package:avail/pages/home-page.dart";
import 'package:avail/pages/script-create-options-page.dart';
import 'package:avail/pages/script-create-page.dart';
import "package:avail/pages/script-page.dart";
import 'package:avail/pages/script-drafts-page.dart';
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
        backgroundColor: Color(0xFFFAFAFA),
        textTheme: TextTheme(
          display4: TextStyle(),
          display3: TextStyle(),
          display2: TextStyle(),
          display1: TextStyle(
              color: Color(0xFF212121),
              fontFamily: "Frank Ruhl Libre",
              fontSize: 34,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25),
          headline: TextStyle(),
          title: TextStyle(fontFamily: "Frank Ruhl Libre"),
          subhead: TextStyle(
              color: Color(0xFF212121),
              fontFamily: "Montserrat",
              fontSize: 16,
              letterSpacing: 0.15,
              fontWeight: FontWeight.w400),
          subtitle: TextStyle(
            color: Color(0xFF212121),
            fontFamily: "Frank Ruhl Libre",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          body1: TextStyle(
              height: 1.4,
              color: Color(0xFF212121),
              fontFamily: "Frank Ruhl Libre",
              fontSize: 14,
              letterSpacing: 0.25,
              fontWeight: FontWeight.w400),
          body2: TextStyle(),
          caption: TextStyle(),
          overline: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w400),

          /// Make all caps
          button: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500,
              letterSpacing: 0.75,
              fontSize: 14),
        ),

        /// Create multiple text themes for different styles
      ),
      routes: {
        "/": (context) => HomePage(),
        "/auth": (context) => AuthPage(),
        "/sound": (context) => SoundPage(),
        "/depiction": (context) => DepictionPage(),
        "/script": (context) => ScriptPage(),
        "/script/options": (context) => ScriptCreateOptionsPage(),
        "/script/drafts": (context) => ScriptDraftsPage(),
        "/script/create": (context) => ScriptCreatePage(),
      },
    );
  }
}
