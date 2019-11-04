import 'dart:async';
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
  Map<String, String> _metadata;
  Timer _updateTimer;
  List<TextEditingController> _bodyControllers;

//  File _addImage;

  @override
  void initState() {
    super.initState();
    _scriptStructure = [];
    _bodyControllers = [];
    _titleFocusNode = FocusNode();
    _lastText = false;
    _bodyIndex = 0;
    _bodies = {};
    _titleFocusNode.addListener(
      () async {
        if (!_titleFocusNode.hasFocus) {
          _scriptRef.setData({
            "title": _title,
            "backup": false,
            "user": widget.user.uid,
            "draft": true,
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
    for (TextEditingController _control in _bodyControllers) {
      _control.dispose();
    }
  }

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
        "uid": widget.user.uid,
        "updated": FieldValue.serverTimestamp(),
      });
    } catch (error) {
      print(error.message);
    }
  }

  void _updateCountdown() {
    _updateTimer = new Timer(
      Duration(seconds: 10),
      () {
        updateDocument();
      },
    );
  }

  void updateDocument() async {
    _scriptRef.setData({
      "backup": false,
      "body": _bodies,
      "draft": true,
      "user": widget.user.uid,
      "scriptStructure": _scriptStructure,
      "updated": FieldValue.serverTimestamp(),
    }, merge: true);
  }

  // This adds a body element, either image or text depending on what the user chooses.
  void _addBody(String type, [ImageSource source]) async {
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
        String imageUrl = await upload(
          _image,
          "script/media",
          "${widget.user.uid}_${FieldValue.serverTimestamp}_$_bodyIndex",
          _contentType,
          _metadata,
        );
        _scriptStructure.add(Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
              width: double.infinity,
              child: Image.network(imageUrl, fit: BoxFit.contain)),
        ));
        _bodies[_bodyIndex.toString()] = {"type": "image", "value": imageUrl};
        _lastText = false;
        break;
      case "text":
        _scriptStructure.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: TextField(
              controller: TextEditingController(),
              maxLines: null,
              style: Theme.of(context).textTheme.body1,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Write to avail...",
              ),
              onChanged: (String body) {
                _bodies[_bodyIndex.toString()] = {
                  "type": "text",
                  "value": "body"
                };
                if (_updateTimer != null && !_updateTimer.isActive) {
                  _updateCountdown();
                }
              },
              autofocus: true,
            ),
          ),
        );
        _lastText = true;
        break;
      default:
        return;
    }
    if (mounted) {
      _bodyIndex++;
      setState(() {});
    }
  }

  /// *** Add document processing, eg update body of said controller
  _newTextEditingController([String _text]) {
    TextEditingController _controller = TextEditingController();
    if (_text != null) {
      _controller..text = _text;
    }
    _bodyControllers.add(_controller);
    return _controller;
  }

//  void _cameraPicker(BuildContext context) async {
//    await showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return SimpleDialog(
//            children: <Widget>[
//              FlatButton.icon(
//                onPressed: () {
//                  _addBody(_bodyIndex, "image", ImageSource.camera);
//                },
//                icon: Icon(Icons.camera),
//                label: Text("CAMERA"),
//              ),
//              FlatButton.icon(
//                onPressed: () {
//                  _addBody(_bodyIndex, "image", ImageSource.gallery);
//                },
//                icon: Icon(Icons.image),
//                label: Text("GALLERY"),
//              )
//            ],
//          );
//        });
//  }

  void _addBodyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      elevation: 1,
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Take a photo"),
              onTap: () {
                _addBody("image", ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Upload an image"),
              onTap: () {
                _addBody("image", ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            _lastText
                ? Container(height: 0)
                : ListTile(
                    leading: Icon(Icons.add_comment),
                    title: Text("Add some text"),
                    onTap: () {
                      _addBody("text");
                      Navigator.pop(context);
                    },
                  ),
            ListTile(
              leading: Icon(Icons.remove),
              title: Text("Add a line break"),
              onTap: () {
                _scriptStructure.add(
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      height: 2,
                      width: double.infinity,
                      color: Colors.grey.shade500),
                );
                _bodies[_bodyIndex.toString()] = {"type": "line"};
                _lastText = false;
                _bodyIndex++;
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_documentId != null) {
      _scriptRef = databaseReference.collection("script").document(_documentId);
      getDocument();
    } else {
      createDocument("script");
    }
    if (_scriptStructure.length < 1) {
      _scriptStructure.add(
        TextField(
          controller: _newTextEditingController()
            ..text = scriptData != null && scriptData["title"] != null
                ? scriptData["title"]
                : "",
          maxLines: null,
          maxLength: 100,
          autofocus: true,
          style: Theme.of(context).textTheme.display1,
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
      _addBody("text");
    }
    return Scaffold(
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add a body element",
        onPressed: () {
          _addBodyBottomSheet(context);
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
        ],
      ),
    );
  }
}
