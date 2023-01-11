import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
          TextField(
          decoration: InputDecoration(labelText: 'Email'),
          onChanged: (value) => _email = value,
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          onChanged: (value) => _password = value,
        ),
        SizedBox(height: 20),
        TextButton(
        child: Text('Login'),
    onPressed: () async {
    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      print(e);
    }
    },
        ),
                SizedBox(height: 20),
                TextButton(
                  child: Text('Sign up'),
                  onPressed: () async {
                    try {
                      var user = await _auth.createUserWithEmailAndPassword(
                          email: _email, password: _password);
                      if (user != null) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                )
              ],
          ),
        ),
    );
  }
}


