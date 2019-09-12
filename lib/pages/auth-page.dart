import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool loading;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Text("LOADING");
    }

    void _signIn() async {
      try {
        if (mounted) {
          setState(() {
            loading = true;
          });
        }
        try {
          await _googleSignIn.disconnect(); // Disconnect previews account
        } catch (error) {
          print(error);
        }
        final GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication _googleAuth =
            await _googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _googleAuth.accessToken,
          idToken: _googleAuth.idToken,
        );
        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;
        if (user != null) {
          print("Sign-in success!");
        }
        loading = false;
      } catch (error) {
        print(error);
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      body: SizedBox.expand(
        child: Container(
          color: Colors.grey.shade900,
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Spacer(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: MaterialButton(
                  height: 48,
                  onPressed: _signIn,
                  color: Colors.grey.shade50,
                  child: Text("GOOGLE SIGN IN",
                      style: Theme.of(context).textTheme.button),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
