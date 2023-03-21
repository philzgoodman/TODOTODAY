import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:todotoday/TodoApp.dart';
import 'package:todotoday/UI/done.dart';
import 'package:todotoday/UI/today_task_page.dart';
import 'package:todotoday/UI/all_tasks_page.dart';
import 'package:todotoday/UI/hashtags_page.dart';
import 'LoginPage.dart';
import 'MessageBox.dart';
import 'TaskCard.dart';
import 'UI/Header.dart';
import 'firebase_options.dart';
import 'global.dart';
import 'package:firebase_storage/firebase_storage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final storageRef = FirebaseStorage.instance.ref();


  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  notes.add("Welcome to TodoToday!");

  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (checkIfLoggedin()) {
      return MaterialApp(
        title: 'TodoToday',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.highContrastDark().copyWith(
            primary: Colors.greenAccent,
            secondary: Colors.green,
            tertiary: Colors.red,
          ),
          fontFamily: 'JetBrainsMono',
        ),
        home: MainPage(),
      );
    } else {
      return MaterialApp(
        title: 'TodoToday',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.highContrastDark().copyWith(
            primary: Colors.greenAccent,
            secondary: Colors.green,
            tertiary: Colors.red,
          ),
          fontFamily: 'JetBrainsMono',
        ),
        home: LoginPage(),
      );
    }
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    TodoApp.setSavedBackgroundColorsFromFirestore();

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                shadowColor: Colors.black87,
                elevation: 6,
                bottom: TabBar(
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  enableFeedback: true,
                  tabs: [
                    Tab(
                        icon: Icon(Icons.all_inbox, color: Colors.redAccent),
                        text: 'BACKLOG'),
                    Tab(
                        icon: Icon(Icons.sunny, color: Color(0xFFFFBD64)),
                        text: 'TODO TODAY'),
                    Tab(
                        icon: Icon(Icons.tag, color: Colors.blue),
                        text: 'TAGS'),
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
                          AllTasksPage(key: UniqueKey()),
                          TodayTaskPage(key: UniqueKey()),
                          HashtagsPage(key: UniqueKey()),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 80,
                    right: 21,
                    child: Transform.scale(
                      scale: .6,
                      child: Column(
                        children: [

                          FloatingActionButton(
                            heroTag: 'settings',
                            backgroundColor: Colors.grey,
                            onPressed: () {
                              showAlertDialogWithSettingsOptions(context);
                            },
                            tooltip: 'Settings',
                            child: const Icon(Icons.settings),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FloatingActionButton(
                            heroTag: 'done',
                            backgroundColor: Colors.grey,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Completed Tasks',textAlign: TextAlign.center,
                                      style: TextStyle(

                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    insetPadding: EdgeInsets.zero,
                                    contentPadding: EdgeInsets.zero,
                                    content: SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * .9,child: DonePage()),

                                  actions: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom:15.0),
                                      child: Center(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Ⓧ Close',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),],
                                  );
                                },
                              );
                            },
                            tooltip: 'DONE',
                            child: const Icon(Icons.done),
                          ),
                        ],
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

  void showAlertDialogWithSettingsOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.redAccent),
                  title: Text('Logout', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    logout();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.color_lens, color: Colors.greenAccent),
                  title: Text('Shuffle Background Colors',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      shuffleAppBackgroundColors();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void logout() {
   TodoApp().signOut();

    }


  void shuffleAppBackgroundColors() {
    setState(() {
      today1 = lighten(Colors.accents[Random().nextInt(Colors.accents.length)]);
      today2 = lighten(Colors.accents[Random().nextInt(Colors.accents.length)]);
      today3 = lighten(Colors.accents[Random().nextInt(Colors.accents.length)]);
      all1 = invertColorBy10percent(today1);
      all2 = invertColorBy10percent(today2);
      all3 = invertColorBy10percent(today3);
      hash1 = invertColorBy10percent(all1);
      hash2 = invertColorBy10percent(all2);
      hash3 = invertColorBy10percent(all3);

      TodoApp.saveNewColorsToFirestore(today1, today2, today3);
    });
  }
}

Color lighten(Color c, [int percent = 30]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 + percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
          (c.blue * f).round())
      .withOpacity(0.7);
}
