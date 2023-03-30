import 'package:flutter/material.dart';

import '../global.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.02,
      child: Card(
        margin: const EdgeInsets.all(0),
        shadowColor: Colors.black,
        elevation: 1,
        color: Colors.black,
        child:  ListTile(
              title: Text("DESCRIPTION",
                  style: TextStyle(
                    fontSize: 9,
                  )),
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              trailing: Transform.scale(
                scale: 0.95,
                child: Wrap(
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
    );
  }
}
