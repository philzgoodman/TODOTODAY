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
      offset: const Offset(15, 20),
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            widget.quantity.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
