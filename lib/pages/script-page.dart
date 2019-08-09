import "dart:ui";

import "package:avail/shared/filter-chip-bar.dart";
import "package:avail/shared/menu-drawer.dart";
import "package:avail/shared/text-styles.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/painting.dart";

final databaseReference = Firestore.instance;

//class ScriptFeaturedCard extends StatelessWidget {
//  ScriptFeaturedCard({
//    Key key,
//    @required this.title,
//    @required this.slug,
//    this.media,
//    this.height = 256,
//  }) : super(key: key);
//  final String title;
//  final String slug;
//  final Object media;
//
//  final double height;
//
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//        child: Container(
//      height: 100,
//      child: Stack(
//        fit: StackFit.expand,
//        children: <Widget>[
//          Positioned(
//            left: 0,
//            top: 0,
//            child: Text(title),
//          )
//        ],
//      ),
//    ));
//  }
//}

class ScriptSecondaryCard extends StatelessWidget {
  ScriptSecondaryCard({
    Key key,
    @required this.title,
    this.media,
    this.duration = 0,
    this.hits = 0,
  }) : super(key: key);
  final String title;
  final media;
  final duration;
  final hits;

  @override
  Widget build(BuildContext context) {
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
                child: Row(children: <Widget>[
                  Expanded(
                    // Implement a stack, to put the bookmark in the bottom left corner
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Secondary headline
                          Container(
                              child: Text(title, style: secondaryHeadline)),
                          // Slug
//                          Padding(
//                              padding: EdgeInsets.only(left: 8, right: 8),
//                              child: Text(slug,
//                                  overflow: TextOverflow.visible,
//                                  softWrap: true,
//                                  maxLines: 4)),
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("${hits / 1000}k"),
                                    Icon(Icons.show_chart),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text("${duration}min"),
                                    Container(child: Icon(Icons.timelapse)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ]),
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
                ])));
      },
    );
  }
}

class ScriptPage extends StatefulWidget {
  _ScriptPageState createState() => _ScriptPageState();
}

class _ScriptPageState extends State<ScriptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Scripts Bottom Left FAB
        floatingActionButton: Container(
            constraints: BoxConstraints(
              minHeight: 80,
              maxHeight: 96,
              minWidth: 80,
              maxWidth: 96,
            ),
            child: Transform.translate(
                offset: Offset(40, 40),
                child: RawMaterialButton(
                  padding: EdgeInsets.only(right: 5, bottom: 10),
                  fillColor: Color(0xFF212121),
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.note_add,
                    color: Color(0xFFFFFFFF),
                    size: 32,
                  ),
                  onPressed: () {
                    print("FAB Pressed");
                  },
                ))),
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
                  stream: databaseReference.collection("script").snapshots(),
                  builder: (BuildContext context, snapshot) {
                    return ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int i) {
                          DocumentSnapshot scriptDocument =
                              snapshot.data.documents[i];
//                            if (scriptDocument["featured"] == true) {
//                              return ScriptFeaturedCard();
//                            }
                          return ScriptSecondaryCard(
                            title: scriptDocument["title"],
                            media: scriptDocument["media"],
                            duration: scriptDocument["duration"], // in minutes
                            hits: scriptDocument["hits"],
                          );
                        });
                  }),
            ),
          ],
        ));
  }
}
