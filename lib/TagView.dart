import 'package:flutter/cupertino.dart';
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
    return SizedBox(
      width: 300,
      height: 480,
      child: ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
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
                  offset: Offset(0, 47), child: const HeaderLabel()),
              ListView.builder(
                scrollDirection: Axis.vertical,
                addAutomaticKeepAlives: false,
                reverse: false,
                physics: ClampingScrollPhysics(),
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
