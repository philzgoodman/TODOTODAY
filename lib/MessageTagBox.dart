import 'package:flutter/material.dart';
import 'package:todotoday/TaskCard.dart';
import 'package:todotoday/global.dart';

class MessageTagBox extends StatefulWidget  {
  String tag = '';
  int index = 0;

  MessageTagBox(this.tag, this.index, {super.key});

  @override
  State<MessageTagBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageTagBox> {
  FocusNode myFocusNode = FocusNode();

  TextEditingController txt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(

          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 360,
            child: Material(
              borderRadius: BorderRadius.circular(5),
              color: getRandomColor(widget.tag, 40),
              shadowColor: Colors.black,
              elevation: 15,
              child: TextField(
                  toolbarOptions:  ToolbarOptions(
                    copy: true,
                    cut: true,
                    paste: true,
                    selectAll: true,
                  ),
                  cursorColor: Colors.deepOrangeAccent,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  focusNode: myFocusNode,
                  keyboardAppearance: Brightness.dark,
                  onSubmitted: (value) {
                    addNewTask(context);
                  },
                  textInputAction: TextInputAction.search,
                  controller: txt,
                  decoration: InputDecoration(
                    hintText: 'Add to this list',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        addNewTask(context);
                      },
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  void addNewTask(BuildContext context) {
    todoApp.createTaskWithHashtag(txt.text, widget.tag);
    txt.clear();
    setState(() {});
  }
}
