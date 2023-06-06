import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todotoday/TaskCard.dart';
import 'package:todotoday/global.dart';

class MessageTagBox extends StatefulWidget {
  String tag = '';
  int index = 0;

  MessageTagBox(this.tag, this.index, {super.key});

  @override
  State<MessageTagBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageTagBox> {
  FocusNode myFocusNode = FocusNode();

  TextEditingController txt = TextEditingController();
  bool isMessageBoxVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
              visible: isMessageBoxVisible,
              child: IconButton(
                onPressed: () {
                  myFocusNode.unfocus();
                  setState(() {
                    isMessageBoxVisible = false;
                  });
                },
                icon: Icon(Icons.keyboard_arrow_down),
              )),
          SizedBox(
            width: 360,
            child: Material(
              borderRadius: BorderRadius.circular(5),
              color: getRandomColor(widget.tag, 50),
              shadowColor: Colors.black,
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: TextField(
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                      cut: true,
                      paste: true,
                      selectAll: true,
                    ),
                    onTap: () {
                      setState(() {
                        isMessageBoxVisible = true;
                        myFocusNode.requestFocus();
                      });
                    },
                    onTapOutside: (value) {
                      setState(() {
                        isMessageBoxVisible = false;
                      });
                    },
                    cursorColor: Colors.deepOrangeAccent,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    focusNode: myFocusNode,
                    selectionControls: MaterialTextSelectionControls(),
                    keyboardAppearance: Brightness.dark,
                    onSubmitted: (value) {
                      addNewTask(context);
                    },
                    textInputAction: TextInputAction.search,
                    controller: txt,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
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
      ),
    );
  }

  void addNewTask(BuildContext context) {
    todoApp.createTaskWithHashtag(txt.text, widget.tag);
    txt.clear();
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (isMessageBoxVisible) {
      setState(() {
        isMessageBoxVisible = false;
      });
    }
  }
}
