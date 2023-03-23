library global;

import 'dart:ui';

import 'TaskCard.dart';
import 'TodoApp.dart';
import 'main.dart';

TodoApp todoApp = TodoApp();
bool loggedIn = false;
List<String> subTitleCount = [];

List<String> notes = [];

int tagLength = 0;

int calculatorResult = 0;

bool isVisible = true;
Color today1 = Color(0xFFB0BD8A);
Color today2 = Color(0xFF356C40);
Color today3 = Color(0xFF34574A);

Color all1 = invertColorBy10percent(today1);
Color all2 = invertColorBy10percent(today2);
Color all3 = invertColorBy10percent(today3);

Color hash1 = invertColorBy10percent(all1);
Color hash2 = invertColorBy10percent(all2);
Color hash3 = invertColorBy10percent(all3);






