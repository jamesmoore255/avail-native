import "package:avail/shared/filter-chip-bar.dart";
import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

final databaseReference = Firestore.instance;

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: HomeBottomAppBarContents(),
        elevation: 8,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF484848),
        onPressed: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: HomeBody(),
    );
  }
}

class HomeBottomAppBarContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: CircleAvatar(backgroundColor: Color(0xFF484848))
            ),
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
            )
          ],
        ));
  }
}

class HomeBodyState extends State<HomeBody> {
//  Widget _searchChipBar() {
//    return IconButton(
//      icon: Icon(Icons.filter_list),
//      onPressed: null,
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          child: Text(testDoc["title"]),
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
                                  child: Text("Media"),
                                  padding: EdgeInsets.all(8)),
                              Column(
                                children: subsections,
                              )
                            ],
                          ));
                    });
              }),
        )
      ],
    ));
  }
}

class HomeBody extends StatefulWidget {
  @override
  HomeBodyState createState() => HomeBodyState();
}
