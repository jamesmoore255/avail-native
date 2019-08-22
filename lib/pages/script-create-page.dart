import "package:avail/shared/filter-chip-bar.dart";
import "package:avail/shared/menu-drawer.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/painting.dart";

final databaseReference = Firestore.instance;

class ScriptCreatePage extends StatefulWidget {
  ScriptCreatePage({
    Key key,
    this.user,

    /// @required
    this.signedIn = true,

    /// @required
    this.id,
  }) : super(key: key);

  /// FirebaseUser type
  final String user;
  final bool signedIn;
  final String id;

  @override
  _ScriptCreatePageState createState() => _ScriptCreatePageState();
}

class _ScriptCreatePageState extends State<ScriptCreatePage> {
  DocumentReference scriptRef =
      databaseReference.collection("script").document();
  Map<String, dynamic> scriptData;
  String documentId;

  void getDocument(String type, String id) async {
    try {
      scriptRef = databaseReference.document("$type/$id");
      final DocumentSnapshot snapshot = await scriptRef.get();
      if (snapshot.exists) {
        setState(() {
          scriptData = snapshot.data;
        });
      }
    } catch (error) {
      print(error.message);
    }
  }

  void createDocument(String type) async {
    try {
      scriptRef = databaseReference.collection(type).document();
      await scriptRef.setData({
        "backup": false,
        "created": FieldValue.serverTimestamp(),
        "hits": 0,
        "user": widget.user,
        "updated": FieldValue.serverTimestamp(),
      });
      documentId = scriptRef.documentID;
    } catch (error) {
      print(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    if (widget.id != null) {
      documentId = widget.id;
      getDocument("script", documentId);
    } else {
      createDocument("script");
    }
    return Scaffold(
      drawer: Drawer(),
      body: Column(
        children: <Widget>[
          // Custom top app bar, small menu with chip bar
          SafeArea(
            child: Stack(
              children: <Widget>[
                ChipBar(),
                MenuDrawer(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16, left: 16),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: TextEditingController()
                    ..text = scriptData != null && scriptData["title"] != null
                        ? scriptData["title"]
                        : "",
                  maxLines: null,
                  maxLength: 100,
                  style: Theme.of(context).textTheme.display1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Title...",
                  ),
                  onChanged: (String title) {
                    scriptRef.setData({
                      "title": title,
                      "backup": false,
                      "user": widget.user,
                      "draft": true,
                      "updated": FieldValue.serverTimestamp(),
                    }, merge: true);
                  },
                ),
                TextField(
                  controller: TextEditingController()
                    ..text = scriptData != null && scriptData["body"] != null
                        ? scriptData["body"]
                        : "",
                  maxLines: null,
                  style: Theme.of(context).textTheme.body1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write to avail...",
                  ),
                  onChanged: (String body) {
                    scriptRef.setData({
                      "backup": false,
                      "body": body,
                      "draft": true,
                      "user": widget.user,
                      "updated": FieldValue.serverTimestamp(),
                    }, merge: true);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
