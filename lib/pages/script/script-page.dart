import "dart:ui";

import "package:avail/shared/filter-chip-bar.dart";
import "package:avail/shared/menu-drawer.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/painting.dart";

final databaseReference = Firestore.instance;

class ScriptPage extends StatefulWidget {
  _ScriptPageState createState() => _ScriptPageState();
}

class _ScriptPageState extends State<ScriptPage> {
  final scriptDoc = databaseReference.collection("script");
  final _bookmarks = Set();

  Widget _buildScriptSecondaryRow(String id, String title, Map media,
      int duration, int hits, bool bookmarked) {
    final bool _isBookmarked = _bookmarks.contains(id);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          elevation: 0,
          child: Container(
            margin: EdgeInsets.all(8),
            constraints: BoxConstraints(
              minHeight: 60,
              maxHeight: 110,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          bottom: -8,
                          right: 0,
                          child: IconButton(
                              alignment: Alignment.bottomCenter,
                              icon: Icon(
                                _isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                size: 36,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_isBookmarked) {
                                    _bookmarks.remove(id);

                                    /// UPDATE USER BOOKMARKS ON FIREBASE DOC
                                  } else {
                                    _bookmarks.add(id);

                                    /// UPDATE USER BOOKMARKS ON FIREBASE DOC
                                  }
                                });
                              })),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Spacer(),
                          // Secondary headline
                          Container(
                            child: Text(
                              title ?? "Title not defined",
                              style: Theme.of(context).textTheme.subhead,
                            ),
                          ),
                          // Slug
//                          Padding(
//                              padding: EdgeInsets.only(left: 8, right: 8),
//                              child: Text(slug,
//                                  overflow: TextOverflow.visible,
//                                  softWrap: true,
//                                  maxLines: 4)),
                          Spacer(flex: 2),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("${hits ?? 0 / 1000}k",
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline),
                                    Icon(Icons.show_chart, size: 12),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("${duration}min",
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline),
                                    Container(
                                        child: Icon(Icons.timelapse, size: 12)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                media != null && media["url"] != null
                    ? Container(
                        constraints: BoxConstraints(
                            minWidth: constraints.minWidth / 4,
                            maxWidth: constraints.maxWidth / 2 - 16,
                            minHeight: constraints.minHeight),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(media["url"]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    : Container(width: 0),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scripts Bottom right FAB
      floatingActionButton: Container(
        constraints: BoxConstraints(
          minHeight: 80,
          maxHeight: 96,
          minWidth: 80,
          maxWidth: 96,
        ),
        child: Transform.translate(
          offset: Offset(30, 30),
          child: RawMaterialButton(
            fillColor: Colors.grey.shade900,
            shape: CircleBorder(),
            child: Icon(
              Icons.note_add,
              color: Color(0xFFFFFFFF),
              size: 40,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/script/options");
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          Expanded(
            child: StreamBuilder(
              stream: databaseReference
                  .collection("script")
                  .orderBy("hits")
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                int totalDocs = snapshot?.data?.documents?.length ?? 0;
                if (totalDocs == 0) {
                  return Text('Loading...');
                }
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int i) {
                    DocumentSnapshot scriptDocument =
                        snapshot.data.documents[i];
//                            if (scriptDocument["featured"] == true) {
//                              return ScriptFeaturedCard();
//                            }
                    return _buildScriptSecondaryRow(
                      scriptDocument.documentID,
                      scriptDocument["title"],
                      scriptDocument["media"],
                      scriptDocument["duration"], // in minutes
                      scriptDocument["hits"],
                      scriptDocument["bookmarked"],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
