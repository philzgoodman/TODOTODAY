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
                  print(userEmail);
                  if (userEmail != null) {
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('users');

                    if (users.where('email', isEqualTo: userEmail).get() == null || (users.where('email', isEqualTo: userEmail).get() == '')) {

                      users.add({
                        'email': userEmail,
                      });

                      users
                          .where('email', isEqualTo: userEmail)
                          .get()
                          .then((value) {
                        for (int i = 0; i < tasks.length; i++) {

                          if (value.docs[0]['taskList']?.contains(tasks[i].name)) {
                            print("Task already exists");
                          } else {
                            tasks[i] = (TodoTask(
                                value.docs[0]['taskList'][i],
                                value.docs[0]['subtitleList'][i],
                                value.docs[0]['isCheckedList'][i] == 'true',
                                value.docs[0]['isTodayList'][i] == 'true',
                                TileColors.TILECOLORS.elementAt(tasks.length)));
                            print("Task added");
                          }

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
