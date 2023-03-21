import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:todotoday/TodoApp.dart';

import '../global.dart';
import 'hashtags_page.dart';

class DocumentEditingScreen extends StatefulWidget {
  String id;


  DocumentEditingScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<DocumentEditingScreen> createState() => _DocumentEditingScreenState();
}

class _DocumentEditingScreenState extends State<DocumentEditingScreen> {


  final HtmlEditorController controller = HtmlEditorController();
  final TextEditingController txt = TextEditingController();
  String s = '';
  String url = '';

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    final Future<String> _calculation = loadTextFromFirebaseStorage(widget.id);

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(Icons.check),
                tooltip: "Save",
                onPressed: () {
                  putStringToFirebaseStorage(txt.text, widget.id);
                }
            ),
          ]
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: 16),
            FutureBuilder<String>(
              future: _calculation,
              // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                List<Widget> children;
                return TextField(
                  maxLines: 8,
                  controller: txt,
                  onChanged: (String value) {

                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }







   getContentsOfTheUrlFile(String url) {
    var httpClient = new HttpClient();
    httpClient.getUrl(Uri.parse(url)).then((request) {
      return request.close();
    }).then((response) {
      response.transform(utf8.decoder).listen((contents) {
        txt.text = contents;
      });
    });


  }

  Future<String> loadTextFromFirebaseStorage(String id) {
    final ref = FirebaseStorage.instance.ref().child('$id.md');
    try {
      return ref.getDownloadURL().then((val) {
        return ref.getDownloadURL().then((value) async {
          print("value is $value");
          await getContentsOfTheUrlFile(value);
          return value.toString();

        });
      });
    } catch (e) {
      print(e);
    }
    return Future.value("");
  }

  void putStringToFirebaseStorage(String text, String id) {
    final ref = FirebaseStorage.instance.ref().child('$id.md');
    ref.putString(text).then((value) {
      print("putString is $value");
    });
  }
}
