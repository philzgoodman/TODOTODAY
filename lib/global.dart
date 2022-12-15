library global;

import 'package:flutter/cupertino.dart';
import 'package:todotoday/todotask.dart';

int currentIndex = 0;
TextEditingController txt = TextEditingController();
bool isEditing = false;
List<TodoTask> tasks = [];
int todayCount = 0;
int allCount = 0;
int doneCount = 0;

late FocusNode myFocusNode;
