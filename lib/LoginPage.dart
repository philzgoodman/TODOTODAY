import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    return GoogleSignInButton(
        clientId: 'clientId',
        loadingIndicator: CircularProgressIndicator(),
        onSignedIn: (UserCredential credential) async {

          await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);



          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            // Name, email address, and profile photo URL
            final name = user.displayName;
            final email = user.email;
            final photoUrl = user.photoURL;

            // Check if user's email is verified
            final emailVerified = user.emailVerified;

            // The user's ID, unique to the Firebase project. Do NOT use this value to
            // authenticate with your backend server, if you have one. Use
            // User.getIdToken() instead.
            final uid = user.uid;
          }




        }
    );
  }
}