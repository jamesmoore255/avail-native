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
    this.user = "testinguserid",

    /// @required
    this.signedIn = true,

    /// @required
    this.id = "3rbQqJ1ZzH1Q93BA06ke",
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

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      getDocument("script", widget.id);
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
                    maxLength: 45,
                    style: Theme.of(context).textTheme.display1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Title...",
                    ),
                    onChanged: (String title) {
//                      title = _title;
//                      Object _set = _scriptDoc.document().setData({
//                        "title": title,
//                        "user": widget.user,
//                        "draft": true,
//                      }, merge: true);
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
//                      _scriptDoc.document().setData({
//                        "body": body,
//                        "user": widget.user,
//                        "draft": true,
//                      }, merge: true);
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }
}
