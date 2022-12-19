import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/main.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:todotoday/todotask.dart';

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
                AuthStateChangeAction<SignedIn>((context, state) {
                  Navigator.of(context).pop();
                  runApp(MyApp());

                  final userEmail = FirebaseAuth.instance.currentUser?.email;
                  if (userEmail != null) {
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('users');

                    if (users.where('email', isEqualTo: userEmail).get() ==
                        null) {
                      users
                          .add({
                            'email': userEmail.toString(),
                            'taskList':
                                tasks.map((e) => e.name.toString()).toList(),
                            'subtitleList':
                                tasks.map((e) => e.subtitle).toList(),
                            'isCheckedList': tasks
                                .map((e) => e.isChecked.toString())
                                .toList(),
                            'isTodayList':
                                tasks.map((e) => e.isToday.toString()).toList(),
                            'taskListLength': tasks.length,
                          })
                          .then((value) => {
                                print("User Added"),
                              })
                          .catchError(
                              (error) => print("Failed to add user: $error"));
                    } else {
                      users
                          .where('email', isEqualTo: userEmail)
                          .get()
                          .then((value) {
                        tasks.clear();
                        for (int i = 0;
                            i < value.docs[0]['taskListLength'];
                            i++) {
                          tasks.add(TodoTask(
                              value.docs[0]['taskList'][i],
                              value.docs[0]['subtitleList'][i],
                              value.docs[0]['isCheckedList'][i] == 'true',
                              value.docs[0]['isTodayList'][i] == 'true',
                              TileColors.TILECOLORS.elementAt(tasks.length)));
                        }
                      });
                    }
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
}
