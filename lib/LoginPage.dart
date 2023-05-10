import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/global.dart';
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
                AuthStateChangeAction<SignedIn>((context, state) {
                  final userEmail = FirebaseAuth.instance.currentUser?.email;
                  print(userEmail);
                  todoApp.initializeTasks();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                  loggedIn = true;
                  setState(() {
                    runApp(MyApp());
                  });
                }),
                AuthStateChangeAction<UserCreated>((context, state) {
                  loggedIn = true;
                  setState(() {
                    runApp(MyApp());
                  });
                }),
              ],
            );
          } else if (state is SignedIn) {
            return MyApp();
          } else if (state is UserCreated) {
            return MyApp();
          }
          {
            return LoginPage();
          }
        },
      ),
    );
  }

  void logIn() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        if (value.user != null) {
          todoApp.initializeTasks();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
          loggedIn = true;
          setState(() {
            runApp(MyApp());
          });
        }
      });
    }
  }
}

bool checkIfLoggedin() {
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  } else {
    return false;
  }
}
