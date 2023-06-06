import 'dart:async';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:todotoday/TodoApp.dart';
import 'package:todotoday/UI/today_task_page.dart';
import 'package:todotoday/UI/all_tasks_page.dart';
import 'package:todotoday/UI/hashtags_page.dart';
import 'LoginPage.dart';
import 'TaskCard.dart';
import 'firebase_options.dart';
import 'global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (checkIfLoggedin()) {
      return MaterialApp(
        title: 'DoToday',
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
        title: 'DoToday',
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
                bottom: const TabBar(
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  enableFeedback: true,
                  tabs: [
                    const Tab(
                        icon: Icon(Icons.all_inbox, color: Colors.redAccent),
                        text: 'BACKLOG'),
                    const Tab(
                        icon: Icon(Icons.sunny, color: Color(0xFFFFBD64)),
                        text: 'TODO TODAY'),
                    const Tab(
                        icon: Icon(Icons.tag, color: Colors.blue),
                        text: 'TAGS'),
                  ],
                ),
                toolbarHeight: 0,
              ),
              body: Stack(
                children: [
                  TabBarView(
                    children: [
                      AllTasksPage(key: UniqueKey()),
                      TodayTaskPage(key: UniqueKey()),
                      HashtagsPage(key: UniqueKey()),
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
                          const SizedBox(
                            height: 30,
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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Ⓧ Close',
                textAlign: TextAlign.center,
              ),
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
