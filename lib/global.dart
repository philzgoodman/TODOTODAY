library global;

import 'package:flutter/cupertino.dart';
import 'package:todotoday/UserBackground.dart';
import 'package:todotoday/todotask.dart';

var subtitles = [];
int currentIndex = 0;
TextEditingController txt = TextEditingController();
bool isEditing = false;
bool signedIn = false;
List<TodoTask> tasks = [];
List<String?> savedList = [];
int todayCount = 0;
int allCount = 0;
int doneCount = 0;
var userBG = UserBackground(defaultBG);
late FocusNode myFocusNode;
List uniqueSubtitles = [];
int tagCount = 1;

List<Color> defaultBG = [
  const Color(0xFFCC7A7A),
  const Color(0xFFDA7493),
  const Color(0xFFB270BE),
];
