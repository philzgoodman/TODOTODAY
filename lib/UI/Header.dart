import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 900,
        ),
        child: Card(
          margin: EdgeInsets.zero,
          shadowColor: Colors.black,
          color: Color(0xFF131313FF),
          elevation: 1,
          child: ListTile(
            title: Text("DESCRIPTION",
                style: TextStyle(
                  fontSize: 9,
                )),
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            trailing: Transform.scale(
              scale: 0.95,
              child: Wrap(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text("DONE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                        )),
                  ),
                  SizedBox(
                    width: 56,
                    child: Text("DELETE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                        )),
                  ),
                  SizedBox(
                    width: 56,
                    child: Text("TODAY",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
