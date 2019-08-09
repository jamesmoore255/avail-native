import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

final databaseReference = Firestore.instance;

class ChipBar extends StatefulWidget {
//  ChipBar({
//    Key key,
//    this.text,
//  }) : super(key: key);
//  final String text;

  @override
  _ChipBarState createState() => _ChipBarState();
}

class _ChipBarState extends State<ChipBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Color(0xFFEEEEEE),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: null,
          )
        ],
      ),
    );
  }
}
