import 'package:avail/pages/auth-page.dart';
import "package:avail/shared/filter-chip-bar.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

final databaseReference = Firestore.instance;

class HomePage extends StatefulWidget {
  HomePage(
      {Key key,
      @required this.signedIn,
      @required this.signOut,
      @required this.user,
      @required this.userData})
      : super(key: key);
  final bool signedIn;
  final GestureTapCallback signOut;
  final FirebaseUser user;
  final Map<String, dynamic> userData;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool signedIn = false;

  homeContents() {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 48.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/auth");
                  },
                  child: CircleAvatar(backgroundColor: Color(0xFF484848))),
              GestureDetector(
                child: Icon(Icons.image, size: 40),
                onTap: () {
                  Navigator.pushNamed(context, "/depiction");
                },
              ),
              VerticalDivider(
                width: 32,
              ),
              GestureDetector(
                child: Icon(Icons.note, size: 40),
                onTap: () {
                  Navigator.pushNamed(context, "/script");
                },
              ),
              GestureDetector(
                child: Icon(Icons.music_note, size: 40),
                onTap: () {
                  Navigator.pushNamed(context, "/sound");
                },
              ),
            ],
          ),
        ),
        elevation: 8,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF484848),
        onPressed: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: <Widget>[
          SafeArea(
            child: ChipBar(),
          ),
          Expanded(
            child: StreamBuilder(
              stream: databaseReference.collection("test").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("Loading...");
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int i) {
                    DocumentSnapshot testDoc = snapshot.data.documents[i];
                    List<Widget> subsections = <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(testDoc["title"],
                            style: Theme.of(context).textTheme.subhead),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(testDoc["type"]),
                      )
                    ];
                    return Card(
                      elevation: 1,
                      child: Row(
                        children: <Widget>[
                          Padding(
                              child: Text("Media"), padding: EdgeInsets.all(8)),
                          Column(
                            children: subsections,
                          )
                        ],
                      ),
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

  @override
  Widget build(BuildContext context) {
    if (widget.signedIn != signedIn) {
      setState(() {
        signedIn = widget.signedIn;
      });
    }
    return IndexedStack(
      index: signedIn ? 0 : 1,
      children: <Widget>[
        Container(
          child: homeContents(),
        ),
        AnimatedOpacity(
          child: AuthPage(),
          opacity: signedIn ? 0 : 1,
          duration: Duration(milliseconds: 500),
        ),
      ],
    );
  }
}
