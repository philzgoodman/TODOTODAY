import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todotoday/main.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

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
                AuthStateChangeAction<SignedIn>((context, state) async {
                  Navigator.of(context).pop();
                  runApp(MyApp());

                  final userEmail = FirebaseAuth.instance.currentUser?.email;
                  print(userEmail);
                  if (userEmail != null) {
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('users');



                    SharedPreferences sharedToday =
                        await SharedPreferences.getInstance();

                    users
                        .where('taskListLength', isGreaterThan: 0)
                        .get()
                        .then((QuerySnapshot querySnapshot) => {
                              querySnapshot.docs.forEach((doc) {
                                sharedToday.setStringList('isTodayList',
                                    doc['isTodayList'].toString().split(','));
                                sharedToday.setStringList('isCheckedList',
                                    doc['isCheckedList'].toString().split(','));
                                sharedToday.setStringList('taskList',
                                    doc['taskList'].toString().split(','));
                                sharedToday.setStringList('subtitleList',
                                    doc['subtitleList'].toString().split(','));
                              })
                            });

                    setState(() {
                      runApp(MyApp());
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
}
