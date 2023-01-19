import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/UI/done.dart';
import 'package:todotoday/UI/today_task_page.dart';
import 'package:todotoday/UI/all_tasks_page.dart';
import 'package:todotoday/UI/hashtags_page.dart';
import 'LoginPage.dart';
import 'MessageBox.dart';
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
  runApp(MyApp());
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
    return DefaultTabController(
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
                  enableFeedback: true,
                  tabs: [
                    Tab(icon: Icon(Icons.all_inbox, color: Colors.redAccent)),
                    Tab(icon: Icon(Icons.sunny, color: Color(0xFFFFBD64))),
                    Tab(icon: Icon(Icons.tag, color: Colors.blue)),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: MessageBox(),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 21,
                    child: Transform.scale(
                      scale: .6,
                      child: FloatingActionButton(
                        heroTag: 'settings',
                        backgroundColor: Colors.grey,
                        onPressed: () {},
                        tooltip: 'Settings',
                        child: const Icon(Icons.settings),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 21,
                    child: Transform.scale(
                      scale: .6,
                      child: FloatingActionButton(
                        heroTag: 'done',
                        backgroundColor: Colors.grey,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.zero,
                                contentPadding: EdgeInsets.zero,
                                content: DonePage(),
                              );
                            },
                          );
                        },
                        tooltip: 'DONE',
                        child: const Icon(Icons.done),
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
