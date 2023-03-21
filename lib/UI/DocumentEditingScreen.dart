import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
  TextEditingController txtedt = TextEditingController(text: "");

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    txtedt.text = notes[0];

    }






  @override
  Widget build(BuildContext context) {





    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Editing"),
        actions: [

          IconButton(
            icon: const Icon(Icons.format_bold),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.format_italic),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.format_underline),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              TodoApp().saveTextAsSubcollectionInFirestore(txtedt.text, widget.id);
              showToast(
                  'Saved Document to Cloud.');
            },
          ),

          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child:
                 TextField(
              controller: txtedt,


              maxLines: 100,
              minLines: 100,


            ),

      ),







    );
  }

  String? getMarkdownFileFromFirebaseStorage(String id) {
    final ref = FirebaseStorage.instance.ref().child('$id.txt');

    ref.getDownloadURL().then((val) {
      ref.getDownloadURL().then((value) {
        print(value);
        return value.toString();


      });
    });
  }



  void saveAsMarkdownFileToFirebaseStorage(String text, id) async {
    final ref = FirebaseStorage.instance.ref().child('$id.md');

    await ref.putString(text);

  }








}




