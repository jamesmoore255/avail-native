import 'dart:io';

import 'package:avail/helpers/uploadStorage.dart';
import "package:avail/shared/filter-chip-bar.dart";
import "package:avail/shared/menu-drawer.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/cupertino.dart";
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/painting.dart";
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

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
  final FirebaseUser user;
  final bool signedIn;
  final String id;

  @override
  _ScriptCreatePageState createState() => _ScriptCreatePageState();
}

class _ScriptCreatePageState extends State<ScriptCreatePage> {
  DocumentReference _scriptRef;
  Map<String, dynamic> scriptData;
  FocusNode _bodyFocusNode;
  FocusNode _titleFocusNode;
  List<Widget> _scriptStructure;
  Map<String, dynamic> _bodies;
  String _documentId;
  String _title;
  bool _lastText;
  int _bodyIndex;
  File _image;
  String _extension;
  String _contentType;
  Map<String, dynamic> _metadata;

//  File _addImage;

  @override
  void initState() {
    super.initState();
    _scriptStructure = [];
    _titleFocusNode = FocusNode();
    _bodyFocusNode = FocusNode();
    _lastText = false;
    _bodyIndex = 0;
    _bodies = {};
    _titleFocusNode.addListener(
          () async {
        if (!_titleFocusNode.hasFocus) {
          print("Title isn't focused");
          _scriptRef.setData({
            "title": _title,
            "backup": false,
            "user": widget.user,
            "draft": true,
            "updated": FieldValue.serverTimestamp(),
          }, merge: true);
        }
      },
    );
    _bodyFocusNode.addListener(
          () async {
        if (!_bodyFocusNode.hasFocus) {
          print("Body isn't focused");
          _scriptRef.setData({
            "backup": false,
            "body": _bodies,
            "draft": true,
            "user": widget.user,
            "updated": FieldValue.serverTimestamp(),
          }, merge: true);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocusNode.dispose();
    _bodyFocusNode.dispose();
  }

//  void titleUpdate() async {}

  void getDocument() async {
    try {
      final DocumentSnapshot snapshot = await _scriptRef.get();
      scriptData = snapshot.data;
      if (snapshot.exists) {
        if (mounted) {
          setState(() {});
        }
      }
    } catch (error) {
      print(error.message);
    }
  }

  void createDocument(String type) async {
    try {
      _scriptRef = databaseReference.collection("script").document();
      _documentId = _scriptRef.documentID;
      await _scriptRef.setData({
        "backup": false,
        "created": FieldValue.serverTimestamp(),
        "hits": 0,
        "user": widget.user,
        "updated": FieldValue.serverTimestamp(),
      });
    } catch (error) {
      print(error.message);
    }
  }

  void addBody(int index, String type, [ImageSource source]) async {
    switch (type) {
      case "image":
        _image = await ImagePicker.pickImage(source: source);
        _extension = p.extension(_image.path);
        switch (_extension) {
          case ".jpg":
          case ".jpeg":
          case ".jpe":
          case ".jif":
          case ".jfif":
          case ".jfi":
            _contentType = "image/jpeg";
            break;
          case ".png":
            _contentType = "image/png";
            break;
          case ".gif":
            _contentType = "image/gif";
            break;
          default:
//            showSnackBar
//                text: "Image file type $_extension not supported",
//                type: "error");
            return;
        }
        _metadata = {"name": p.basename(_image.path), "user": widget.user.uid};
        upload(
          _image,
          "script/media",
          "${widget.user.uid}_${FieldValue.serverTimestamp}_$index",
          _contentType,
          _metadata,
        );
//        _scriptStructure.add();
        break;
      case "text":
        _scriptStructure.add(
          TextField(
            controller: TextEditingController()
              ..text = scriptData != null && scriptData["body"] != null
                  ? scriptData["body"]
                  : "",
            maxLines: null,
            style: Theme
                .of(context)
                .textTheme
                .body1,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Write to avail...",
            ),
            onChanged: (String body) {
              _bodies[index.toString()] = body;
            },
            focusNode: _bodyFocusNode,
            autofocus: true,
          ),
        );
        break;
      default:
        return;
    }
    _lastText = true;
    if (mounted) {
      setState(() {});
    }
  }

  void _addBodyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add_a_photo),
              title: Text("Add a photo"),
            ),
            ListTile(
              leading: Icon(Icons.add_comment),
              title: Text("Add some text"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_documentId != null) {
//      _documentId = widget.id;
      _scriptRef = databaseReference.collection("script").document(_documentId);
      getDocument();
    } else {
      createDocument("script");
    }
    if (_scriptStructure.length < 1) {
      _scriptStructure.add(
        TextField(
          controller: TextEditingController()
            ..text = scriptData != null && scriptData["title"] != null
                ? scriptData["title"]
                : "",
          maxLines: null,
          maxLength: 100,
          autofocus: true,
          style: Theme
              .of(context)
              .textTheme
              .display1,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Title...",
          ),
          onChanged: (String title) {
            _title = title;
          },
          focusNode: _titleFocusNode,
        ),
      );
    }
    return Scaffold(
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add a body element",
        onPressed: () {
          _addBodyBottomSheet(context);
//          addBody(_bodyIndex, "image", ImageSource.camera);
//          _bodyIndex++;
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.grey.shade900.withOpacity(.8),
      ),
      body: ListView(
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
              children: _scriptStructure,
            ),
          ),
//          _lastText != null && _lastText
//              ? Container(height: 0)
//              : Container(
//                  height: 64,
//                  child: RawMaterialButton(
//                    onPressed: () {
//                      addBody(_bodyIndex, "image", ImageSource.camera);
//                      _bodyIndex++;
//                    },
//                    child: Icon(Icons.add, size: 32),
//                    fillColor: Colors.grey.shade50.withOpacity(0.8),
//                  ),
//                ),
        ],
      ),
    );
  }
}
