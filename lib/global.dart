library global;

import 'package:flutter/cupertino.dart';
import 'package:todotoday/UserBackground.dart';
import 'package:todotoday/todotask.dart';

var subtitles = [];
int currentIndex = 0;
TextEditingController txt = TextEditingController();
bool isEditing = false;
List<TodoTask> tasks = [];
int todayCount = 0;
int allCount = 0;
int doneCount = 0;
var userBG = UserBackground(defaultBG);
late FocusNode myFocusNode;
List uniqueSubtitles = [];
int tagCount = 1;

List<Color> defaultBG = [
  Color(0xFFCC7A7A),
  Color(0xFFDA7493),
  Color(0xFFB270BE),
];
