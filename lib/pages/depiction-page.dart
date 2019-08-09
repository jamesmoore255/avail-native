import "dart:ui";

import "package:avail/shared/filter-chip-bar.dart";
import "package:avail/shared/menu-drawer.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/painting.dart";

final databaseReference = Firestore.instance;

class DepictionPage extends StatefulWidget {
  _DepictionPageState createState() => _DepictionPageState();
}

class _DepictionPageState extends State<DepictionPage> {
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
                    Icons.add_a_photo,
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
                  MenuDrawer(color: Color(0xFFFFEE58)),
                ],
              ),
            ),
          ],
        ));
  }
}
