import 'package:flutter/material.dart';
class MessageBox extends StatefulWidget {
  MessageBox({super.key});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}


class _MessageBoxState extends State<MessageBox> {
  TextEditingController txt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          controller: txt,
          decoration: InputDecoration(
            hintText: 'New Task...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
