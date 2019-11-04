import 'package:avail/pages/auth-page.dart';
import "package:avail/pages/depiction-page.dart";
import "package:avail/pages/home-page.dart";
import 'package:avail/pages/script/script-options-page.dart';
import 'package:avail/pages/script/script-create-page.dart';
import 'package:avail/pages/script/script-page.dart';
import 'package:avail/pages/script/script-drafts-page.dart';
import "package:avail/pages/sound-page.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String language;
  bool signedIn;
  FirebaseUser user;
  Map<String, dynamic> userData;

  void _signOut() async {
    await _auth.signOut();
    print("signed out");
    signedIn = false;
    user = null;
    if (mounted) {
      setState(() {});
    }
  }

  void _authStateListener() async {
    print("Inside authstatelistener");
    FirebaseAuth.instance.onAuthStateChanged.listen(
      (FirebaseUser userObject) async {
        signedIn = userObject != null ? true : false;
        print("Signedin: $signedIn");
        user = signedIn ? userObject : null;
        if (mounted) setState(() {});
        if (signedIn) {
          getUserData();
        }
      },
    );
  }

  void getUserData() async {
    if (user.uid == null) {
      print("uid is null");
      return;
    }
    try {
      DocumentSnapshot snapshot =
          await Firestore.instance.collection("user").document(user.uid).get();
      userData = snapshot.data;
    } catch (error) {
      print("User data error: ${error.message}");
    }
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    language = 'en';
    signedIn = false;
    userData = {};
    _authStateListener();
  }

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
        "/": (context) => HomePage(
              user: user,
              signedIn: signedIn,
              signOut: _signOut,
              userData: userData,
            ),
        "/auth": (context) => AuthPage(),
        "/sound": (context) => SoundPage(),
        "/depiction": (context) => DepictionPage(),
        "/script": (context) => ScriptPage(),
        "/script/options": (context) => ScriptCreateOptionsPage(
              user: user,
              signedIn: signedIn,
              signOut: _signOut,
              userData: userData,
            ),
        "/script/drafts": (context) => ScriptDraftsPage(),
        "/script/create": (context) => ScriptCreatePage(
          user: user,
          signedIn: signedIn,
//          signOut: _signOut,
//          userData: userData,
        ),
      },
    );
  }
}
