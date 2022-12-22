import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:todotoday/firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todotoday/LoginPage.dart';
import 'package:todotoday/MessageBox.dart';
import 'package:todotoday/QuantityBadge.dart';
import 'package:todotoday/TileColors.dart';
import 'package:todotoday/UserBackground.dart';
import 'package:todotoday/all.dart';
import 'package:todotoday/global.dart';
import 'package:todotoday/tags.dart';
import 'package:todotoday/today.dart';
import 'package:todotoday/todotask.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  initState() {
    SharedPreferences.getInstance().then((prefs) {

      if (!signedIn)getSavedPrefsToTasks();


    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOTODAY',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.highContrastDark().copyWith(
          primary: Colors.greenAccent,
          secondary: Colors.green,
          tertiary: Colors.red,
        ),
        fontFamily: 'Courier',
      ),
      home: MyHomePage(
        title: '',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  State<MyHomePage> createState() => _MyHomePageState();

  final String title;
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          isEditing = false;
        },
        child: Stack(
          children: [
            userBG,
            Scaffold(
              backgroundColor: Colors.black26,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                shadowColor: Colors.black87,
                elevation: 6,
                bottom: TabBar(
                  enableFeedback: true,
                  tabs: [
                    Stack(
                      children: [
                        Tab(
                            icon:
                                Icon(Icons.all_inbox, color: Colors.redAccent)),
                        QuantityBadge(getAllCount()),
                      ],
                    ),
                    Stack(
                      children: [
                        Tab(icon: Icon(Icons.sunny, color: Color(0xFFFFBD64))),
                        QuantityBadge(getTodayCount()),
                      ],
                    ),
                    Stack(
                      children: [
                        Tab(icon: Icon(Icons.tag, color: Colors.blue)),
                        QuantityBadge(getTagCount()),
                      ],
                    ),
                  ],
                ),
                toolbarHeight: 0,
              ),
              body: Stack(
                children: [
                  Stack(
                    children: [
                      TabBarView(
                        children: [
                          All(
                            key: ValueKey<String>(tasks.toString()),
                            title: '',
                          ),
                          Today(
                            key: UniqueKey(),
                            title: '',
                          ),
                          Tags(
                            key: UniqueKey(),
                            title: '',
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:8.0),
                    child: MessageBox(),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 21,
                    child: Transform.scale(
                      scale: .6,
                      child: FloatingActionButton(
                        backgroundColor: Colors.grey,
                        onPressed: () {
                          _showDialog(context);
                        },
                        tooltip: 'Add',
                        child: const Icon(Icons.settings),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> getSavedPrefsToTasks() async {
  SharedPreferences sharedToday = await SharedPreferences.getInstance();

  List<String>? taskList = [];
  List<String>? subtitleList = [];
  List<String>? isCheckedList = [];
  List<String>? isTodayList = [];

  if (sharedToday != null) {
    if (sharedToday.containsKey("taskListLength")) {
      int? nTask = sharedToday.getInt('taskListLength');

      if (sharedToday.containsKey("taskList")) {
        taskList = sharedToday.getStringList('taskList');
      }
      if (sharedToday.containsKey("subtitleList")) {
        subtitleList = sharedToday.getStringList('subtitleList');
      }
      if (sharedToday.containsKey("isCheckedList")) {
        isCheckedList = sharedToday.getStringList('isCheckedList');
      }
      if (sharedToday.containsKey("isTodayList")) {
        isTodayList = sharedToday.getStringList('isTodayList');
      }

      for (int i = 0; i < nTask!; i++) {
        bool isChecked = false;
        bool isToday = false;

        if (isCheckedList![i] == "true") {
          isChecked = true;
        }

        if (isTodayList![i] == "true") {
          isToday = true;
        }
        tasks.add(TodoTask(taskList![i], subtitleList![i], isChecked, isToday,
            TileColors.TILECOLORS.elementAt(tasks.length)));
      }
    }
  }
  print("Loaded SharedPrefs");
}

int getTodayCount() {
  int n = 0;
  for (var i = 0; i < tasks.length; i++) {
    if (tasks[i].isToday) {
      n++;
    }
  }
  return n;
}

int getAllCount() {
  int n = 0;
  for (var i = 0; i < tasks.length; i++) {
    if (!tasks[i].isChecked && !tasks[i].isToday) {
      n++;
    }
  }
  return n;
}

int getTagCount() {
  for (var i = 0; i < tasks.length; i++) {
    subtitles.add(tasks[i].subtitle);
  }

  uniqueSubtitles = subtitles.toSet().toList();

  return uniqueSubtitles.length;
}

void _showDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        backgroundColor: Color(0xE8231216),
        title: new TextButton(
          onPressed: () {
            tasks.clear();
            clearSharedPrefs();
            deleteFirestore();
            runApp(MyApp());
          },
          child: const Text(
            "Clear All Tasks",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 15,
            ),
          ),
        ),
        content: TextButton(
          onPressed: () {
            userBG.userColorList.clear();
            userBG = UserBackground([
              TileColors.TILECOLORS
                  .elementAt(Random().nextInt(TileColors.TILECOLORS.length)),
              TileColors.TILECOLORS
                  .elementAt(Random().nextInt(TileColors.TILECOLORS.length)),
              TileColors.TILECOLORS
                  .elementAt(Random().nextInt(TileColors.TILECOLORS.length))
            ]);
            Navigator.of(context).pop();
            runApp(MyApp());
          },
          child: SizedBox(
            width: 300,
            height: 400,
            child: Column(
              children: [
                const Text(
                  textAlign: TextAlign.center,
                  "Shuffle Background Colors",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
                if (!signedIn)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('Login'),
                    ),
                  ),
                if (signedIn)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {
                        signOut();
                        tasks.clear();
                        runApp(MyApp());
                      },
                      child: Text('Logout'),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();

                FocusManager.instance.primaryFocus?.unfocus();
              }),
        ],
      );
    },
  );
}

signOut() {
  FirebaseUIAuth.signOut();
  signedIn = false;
  runApp(MyApp());
}

void clearSharedPrefs() {
  SharedPreferences.getInstance().then((prefs) {
    prefs.clear();
  });
}
