library global;

import 'package:flutter/cupertino.dart';
import 'package:todotoday/UserBackground.dart';
import 'package:todotoday/todotask.dart';

int currentIndex = 0;
TextEditingController txt = TextEditingController();
bool isEditing = false;
List<TodoTask> tasks = [];
int todayCount = 0;
int allCount = 0;
int doneCount = 0;
var userBG =  UserBackground(defaultBG);
late FocusNode myFocusNode;

List<Color> defaultBG = [
  Color(0xFFE57373),
  Color(0xFFF06292),
  Color(0xFFBA68C8) ,];