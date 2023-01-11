import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/today_task_page.dart';
import 'package:todotoday/all_tasks_page.dart';
import 'package:todotoday/hashtags_page.dart';
import 'LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MessageBox.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainPage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
   {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black26,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          shadowColor: Colors.black87,
          elevation: 6,
          bottom: TabBar(
            tabs: [
              Tab(
                  icon:
                      Icon(Icons.all_inbox, color: Colors.redAccent)),
              Tab(icon: Icon(Icons.sunny, color: Color(0xFFFFBD64))),
              Tab(icon: Icon(Icons.tag, color: Colors.blue)),
            ],
          ),
          toolbarHeight: 0,
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                AllTasksPage(),
                TodayTaskPage(),
                HashtagsPage(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: MessageBox(),
            ),
            Transform.scale(
              scale: .6,
              child: FloatingActionButton(
                backgroundColor: Colors.grey,
                onPressed: () {},
                tooltip: 'Add',
                child: const Icon(Icons.settings),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
