import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderLabel extends StatelessWidget {
  const HeaderLabel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Material(
        surfaceTintColor: Colors.blue,
        elevation: 5,
        shadowColor: Colors.black45,
        child: ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          textColor: Colors.white,
          tileColor: Colors.black45,
          title: const Text(
              style: TextStyle(color: Colors.white, fontSize: 14), "ITEM"),
          trailing: Wrap(
            children: const [
              SizedBox(
                  width: 50,
                  child: Opacity(
                    opacity: 1,
                    child: Text(
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                        "DONE"),
                  )),
              SizedBox(width: 25),
              SizedBox(
                  width: 50,
                  child: Text(
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                      'TODAY')),
            ],
          ),
        ),
      ),
    );
  }
}
