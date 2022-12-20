import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todotoday/main.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:todotoday/todotask.dart';
import 'MessageBox.dart';
import 'TileColors.dart';
import 'global.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//https://github.com/firebase/flutterfire/blob/master/packages/firebase_ui_auth/doc/providers/email.md
    return Scaffold(
      body: AuthFlowBuilder<EmailAuthController>(
        builder: (context, state, ctrl, child) {
          if (state is AwaitingEmailAndPassword) {
            return SignInScreen(
              actions: [
                AuthStateChangeAction<SignedIn>((context, state)  {
                  final userEmail = FirebaseAuth.instance.currentUser?.email;
                  print(userEmail);
                  if (userEmail != null) {
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('users');
                    users
                        .where('taskListLength', isGreaterThan: 0)
                        .get()
                        .then((QuerySnapshot querySnapshot) => {
                              querySnapshot.docs.forEach((doc) async {
                                if (doc['email'] == userEmail) {
                                  int? nTask = doc['taskListLength'];
                                  for (int i = 0; i < nTask!; i++) {
                                    bool isChecked = false;
                                    bool isToday = false;

                                    if (doc['isCheckedList'][i] == "true") {
                                      isChecked = true;
                                    }

                                    if (doc['isTodayList'][i] == "true") {
                                      isToday = true;
                                    }

                                      tasks.add(TodoTask(
                                          doc['taskList'][i],
                                          doc['subtitleList'][i],
                                          isChecked,
                                          isToday,
                                          TileColors.TILECOLORS
                                              .elementAt(tasks.length)));

                                  }

                                  saveToShared();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyApp()));
                                  runApp(MyApp());
                                }
                              })
                            });
                  }
                }),
              ],
            );
          } else if (state is SigningIn) {
            return CircularProgressIndicator();
          } else if (state is AuthFailed) {
            return ErrorText(exception: state.exception);
          } else {
            return Text('Unknown state $state');
          }
        },
      ),
    );
  }

  void updateText() {
    setState(() {
      if (DefaultTabController.of(context)?.index == 1) {
        tasks.add(TodoTask(txt.text, txt.text, false, true,
            TileColors.TILECOLORS.elementAt(tasks.length)));
      } else {
        tasks.add(TodoTask(txt.text, txt.text, false, false,
            TileColors.TILECOLORS.elementAt(tasks.length)));
      }

      txt.clear();
      for (var i = 0; i < tasks.length; i++) {
        getSubtitle(i);
      }
    });
    txt.clear();

    saveToShared();

    if (FirebaseAuth.instance.currentUser != null) saveToFireStore();
  }
}
