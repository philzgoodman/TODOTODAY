import 'package:flutter/material.dart';
import 'package:todotoday/global.dart';

class MessageBox extends StatefulWidget with ChangeNotifier {
  MessageBox({super.key});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}


class _MessageBoxState extends State<MessageBox> {
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
                    style:
                    const TextStyle(color: Colors.white, fontSize: 14),
                    focusNode: myFocusNode,
                    keyboardAppearance: Brightness.dark,
                    onSubmitted: (value) {

                        addNewTask(context);

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
      ),
      ],
    );
  }

  void addNewTask(BuildContext context) {

    if (DefaultTabController.of(context)!.index == 1) {
      todoApp.createTask(txt.text, true);
    }
    else {
      todoApp.createTask(txt.text, false);
    }
    txt.clear();

  }


}

