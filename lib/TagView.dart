import 'package:flutter/cupertino.dart';
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
    return Container(
      color: Color(0xFF7479D2).withOpacity(0.2),
      child: Stack(
        children: [
          SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                const HeaderLabel(),
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
                      return tasks[index];
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
      ),
    );
  }
}
