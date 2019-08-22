import "package:avail/shared/filter-chip-bar.dart";
import "package:avail/shared/menu-drawer.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

final databaseReference = Firestore.instance;

class ScriptCreateOptionsPage extends StatefulWidget {
  ScriptCreateOptionsPage({
    Key key,
    this.user,
    this.signedIn = true,
  }) : super(key: key);

  /// FirebaseUser type
  final String user;
  final bool signedIn;

  @override
  _ScriptCreateOptionsPageState createState() =>
      _ScriptCreateOptionsPageState();
}

class _ScriptCreateOptionsPageState extends State<ScriptCreateOptionsPage> {
  Divider verticalSpacer = Divider(height: 16);

  @override
  Widget build(BuildContext context) {
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
}
