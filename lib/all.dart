import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/done.dart';
import 'package:todotoday/global.dart';

class All extends StatefulWidget {
  All({Key? key, required String title}) : super(key: key);

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const HeaderLabel(),
              ListView.builder(
                scrollDirection: Axis.vertical,
                addAutomaticKeepAlives: false,
                reverse: true,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  if (!tasks[index].isChecked && !tasks[index].isToday) {
                    return tasks[index];
                  } else {
                    return const SizedBox(
                      height: 0,
                    );
                  }
                },
              ),
              SizedBox(
                height: 110,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderLabel extends StatelessWidget {
  const HeaderLabel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      textColor: Colors.white,
      tileColor: Colors.black45,
      title: const Text(
          style: TextStyle(color: Colors.white, fontSize: 14), "ITEM"),
      trailing: Wrap(
        children: const [
          SizedBox(
              width: 50,
              child: Text(
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                  "DONE")),
          SizedBox(width: 25),
          SizedBox(
              width: 50,
              child: Text(
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                  'TODAY')),
        ],
      ),
    );
  }
}
