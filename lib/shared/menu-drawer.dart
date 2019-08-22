import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class MenuDrawer extends StatelessWidget {
  MenuDrawer({Key key, this.color = const Color(0xFF212121)}) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipBehavior: Clip.antiAlias,
        clipper: MenuClipper(),
        child: GestureDetector(
          onTap: () {
            print("Nav clicked");
          },
          child: Material(
            elevation: 5,
            color: color,
            child: Container(
              padding: EdgeInsets.only(right: 32),
              constraints: BoxConstraints(
                minWidth: 80,
                maxWidth: 120,
                minHeight: 56,
                maxHeight: 64,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    iconSize: 28,
                    icon: Icon(Icons.arrow_back_ios),
                    color: Color(0xFFFAFAFA),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  // Profile avatar for accessory pages
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                      child: CircleAvatar(backgroundColor: Color(0xFF484848))
                  ),
//                  Text("Avail", style: TextStyle(fontSize: 24)),
//                  Icon(Icons.more_vert, size: 36),
                ],
              ),
            ),
          ),
        ));
  }
}

class MenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0,
        size.height); // this draws the line from current point to the left bottom position of widget
    path.lineTo(size.width - 32,
        size.height); // this draws the line from current point to the right bottom position of the widget.
    path.lineTo(size.width,
        0); // this draws the line from current point to the right top position of the widget
    path.close();
    return path;
  }

  @override
  bool shouldReclip(MenuClipper oldClipper) => false;
}
