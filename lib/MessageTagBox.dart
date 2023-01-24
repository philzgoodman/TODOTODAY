import 'package:flutter/material.dart';
import 'package:todotoday/global.dart';

import 'UI/hashtags_page.dart';
import 'main.dart';

class MessageTagBox extends StatefulWidget with ChangeNotifier {
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: SizedBox(
              width: 360,
              child: Material(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFF7E5112),
                shadowColor: Colors.black,
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: TextField(
                      toolbarOptions: const ToolbarOptions(
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
          ),
        ),
      ],
    );
  }

  void addNewTask(BuildContext context) {
    todoApp.createTaskWithHashtag(txt.text, widget.tag);
    txt.clear();
    subTitleCount[widget.index]++;
    setState(() {});
  }
}
