import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController txt = TextEditingController();
  String s = '';
  String url = '';

  @override
  void initState() {

      loadTextFromFirebaseStorage(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
             TextField(
                  maxLines: 8,
                  controller: txt,
                  onChanged: (String value) {

                  },


            ),
          ],
        ),
      ),
    );
  }

  void loadTextFromFirebaseStorage(String id) {


    try {
      final ref = FirebaseStorage.instance.ref().child('$id.md');

      ref.getDownloadURL().then((val) {
        ref.getDownloadURL().then((value) {
          url = value;
        }).then((value) {
          var httpClient = new HttpClient();
          httpClient.getUrl(Uri.parse(url)).then((request) {
            return request.close();
          }).then((response) {
            response.transform(utf8.decoder).listen((contents) {
              txt.text = contents;
            });
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void putStringToFirebaseStorage(String text, String id) {
    final ref = FirebaseStorage.instance.ref().child('$id.md');
    ref.putString(text).then((value) {
      print("putString is $value");
    });
  }
}
