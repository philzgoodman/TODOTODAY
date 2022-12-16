import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class QuantityBadge extends StatefulWidget {
  int quantity = 0;

  QuantityBadge(this.quantity, {super.key});

  @override
  State<QuantityBadge> createState() => _QuantityBadgeState();
}

class _QuantityBadgeState extends State<QuantityBadge> {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(17, 23),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                child: child,
                position: Tween<Offset>(
                        begin: Offset(0.0, -0.5), end: Offset(0.0, 0.0))
                    .animate(animation),
              );
            },
            child: Text(
              key: ValueKey<String>(widget.quantity.toString()),
              widget.quantity.toString(),
              style: TextStyle(
                color: Color(0xFFFFBD64),
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
