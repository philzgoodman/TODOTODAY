import 'package:flutter/material.dart';

import '../global.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -6),
      child: Container(
        color: Color(0x54000000),
        height: 38,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: ListTile(
              title: Text("DESCRIPTION",
                  style: TextStyle(
                    fontSize: 9,
                  )),
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
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
