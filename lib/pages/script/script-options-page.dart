import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

import "../../shared/filter-chip-bar.dart";
import "../../shared/menu-drawer.dart";
import '../auth-page.dart';

final databaseReference = Firestore.instance;

class ScriptCreateOptionsPage extends StatefulWidget {
  ScriptCreateOptionsPage(
      {Key key,
      @required this.signedIn,
      @required this.signOut,
      @required this.user,
      @required this.userData})
      : super(key: key);
  final bool signedIn;
  final GestureTapCallback signOut;
  final FirebaseUser user;
  final Map<String, dynamic> userData;

  @override
  _ScriptCreateOptionsPageState createState() =>
      _ScriptCreateOptionsPageState();
}

class _ScriptCreateOptionsPageState extends State<ScriptCreateOptionsPage> {
  bool signedIn = false;
  Divider verticalSpacer = Divider(height: 16);

  scriptOptionsContents() {
    return Scaffold(
      drawer: Drawer(),
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Stack(
              children: <Widget>[
                ChipBar(),
                MenuDrawer(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  minWidth: 260,
                  height: 64,
                  elevation: 2,
                  onPressed: () {
                    Navigator.pushNamed(context, "/script/create");
                  },
                  color: Colors.grey.shade200,
                  child: Text(
                    "CREATE NEW",
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                verticalSpacer,
                MaterialButton(
                  minWidth: 260,
                  height: 64,
                  elevation: 2,
                  onPressed: () {
                    Navigator.pushNamed(context, "/script/drafts");
                  },
                  color: Colors.grey.shade200,
                  child: Text(
                    "DRAFTS",
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                verticalSpacer,
                MaterialButton(
                  minWidth: 260,
                  height: 64,
                  elevation: 2,
                  onPressed: () {
                    print("PUBLISHED ARTICLES");
                  },
                  color: Colors.grey.shade200,
                  child: Text(
                    "PUBLISHED ARTICLES",
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.signedIn != signedIn) {
      setState(() {
        signedIn = widget.signedIn;
      });
    }
    return IndexedStack(
      index: signedIn ? 0 : 1,
      children: <Widget>[
        Container(
          child: scriptOptionsContents(),
        ),
        AnimatedOpacity(
          child: AuthPage(),
          opacity: signedIn ? 0 : 1,
          duration: Duration(milliseconds: 500),
        ),
      ],
    );
  }
}
