import 'package:flutter/material.dart';
import 'package:todotoday/HeaderLabel.dart';
import 'package:todotoday/global.dart';

class TagView extends StatefulWidget {
  String hashtag = '';

  TagView(this.hashtag, {super.key});

  @override
  State<TagView> createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.5,
      heightFactor: 1,
      child: ShaderMask(
        shaderCallback: (rect) {
          return const LinearGradient(
            begin: Alignment(.5, .5),
            end: Alignment(.5, 1),
            colors: [Colors.black, Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Transform.translate(
                offset: const Offset(0, 30),
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
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                addAutomaticKeepAlives: false,
                reverse: false,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  if (tasks[index].subtitle == widget.hashtag) {
                    return tasks[index];
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
