import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:google_sign_in/google_sign_in.dart";
import "package:http/http.dart" as http;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    "email"
  ]
);

class AuthPage extends StatefulWidget {
  @override
  State createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }
//
//  Future<void> _handleGetContact() async {
//    setState(() {
//      _contactText = "Loading contact info...";
//    });
//    final http.
//  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      print("We signed in yo");
    } catch (error) {
      print(error);
    }
  }

   Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Google sign in"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text("Sign in yo"),
            RaisedButton(
              child: Text("SIGN IN"),
              onPressed: _handleSignIn,
            )
          ],
        ),
    );
  }

}
