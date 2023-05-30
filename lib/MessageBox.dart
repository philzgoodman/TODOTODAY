import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todotoday/global.dart';

class MessageBox extends StatefulWidget  {
  MessageBox({super.key});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
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
              child: IconButton(onPressed: () {myFocusNode.unfocus();
                setState(() {isMessageBoxVisible = false;});
                }, icon: Icon(Icons.keyboard_arrow_down),)),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: SizedBox(
              width: 360,
              child: Material(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black87,
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
                      selectionControls: MaterialTextSelectionControls(),

                      onTap: () {
                        setState(() {
                          isMessageBoxVisible = true;
                          myFocusNode.requestFocus();
                        });
                      },

                      keyboardAppearance: Brightness.dark,
                      onSubmitted: (value) {
                        addNewTask(context);
                      },

                      onTapOutside: (value) {
                        setState(() {
                          isMessageBoxVisible = false;
                        });
                      },

                      textInputAction: TextInputAction.search,
                      controller: txt,
                      decoration: InputDecoration(
                        hintText: 'Enter a task',
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

        ],
      ),
    );
  }

  void addNewTask(BuildContext context) {
    if (DefaultTabController.of(context)!.index == 1) {
      todoApp.createTask(txt.text, true);
    } else {
      todoApp.createTask(txt.text, false);
    }
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
