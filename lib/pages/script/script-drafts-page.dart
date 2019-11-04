import "package:avail/shared/filter-chip-bar.dart";
import "package:avail/shared/menu-drawer.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/painting.dart";

final databaseReference = Firestore.instance;

class ScriptDraftsPage extends StatefulWidget {
  ScriptDraftsPage({
    Key key,
    this.user,
  }) : super(key: key);

  /// FirebaseUser type
  final String user;

  @override
  _ScriptDraftsPageState createState() => _ScriptDraftsPageState();
}

class _ScriptDraftsPageState extends State<ScriptDraftsPage> {
  @override
  Widget build(BuildContext context) {
    Widget horizontalSpacer = Container(width: 16);
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
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream: databaseReference
                        .collection("script")
                        .where("user", isEqualTo: widget.user)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      int totalDocs = snapshot?.data?.documents?.length ?? 0;
                      if (totalDocs == 0) {
                        return Text('Loading...');
                      }
                      return ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int i) {
                          DocumentSnapshot scriptDraftDoc =
                              snapshot.data.documents[i];
                          return Dismissible(
                            key: Key(scriptDraftDoc.documentID),
                            child: ListTile(
                              onTap: () {
                                // Open script create page with corresponding id,
                                // to load the right draft
                                print("List tile pressed");
                              },
                              title: Text(
                                scriptDraftDoc["title"] ?? "Title...",
                                style: Theme.of(context).textTheme.subhead,
                              ),
                              subtitle: Text(
                                scriptDraftDoc["body"] != null
                                    ? "${scriptDraftDoc["body"].substring(0, 45)}..."
                                    : "This is a subtitle",
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                              trailing: Chip(
                                label: Text(
                                  "DRAFT",
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.amberAccent.shade200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(Icons.delete),
                                  horizontalSpacer,
                                  Text(
                                    "DELETE",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  horizontalSpacer,
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
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
