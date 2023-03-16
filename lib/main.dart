import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/TodoApp.dart';
import 'package:todotoday/UI/done.dart';
import 'package:todotoday/UI/today_task_page.dart';
import 'package:todotoday/UI/all_tasks_page.dart';
import 'package:todotoday/UI/hashtags_page.dart';
import 'LoginPage.dart';
import 'MessageBox.dart';
import 'UI/Header.dart';
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: MessageBox(),
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
                            onPressed: () {showAlertDialogWithSettingsOptions(context);},
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

              ],
            ),
          ),
        );
      },
    );
  }

  void logout() {
TodoApp().signOut();  }
}
