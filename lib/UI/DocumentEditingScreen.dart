import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/TodoApp.dart';

import 'hashtags_page.dart';

class DocumentEditingScreen extends StatefulWidget {


  final String id;
  final bool hasDocument;
   DocumentEditingScreen(this.id, this.hasDocument, {Key? key}) : super(key: key);

  @override
  State<DocumentEditingScreen> createState() => _DocumentEditingScreenState();



}

class _DocumentEditingScreenState extends State<DocumentEditingScreen> {
  TextEditingController txtedt = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    if (widget.hasDocument) {
     getDocumentFromFirebaseStorage(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Editing"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
              saveAsMarkdownFileToFirebaseStorage(txtedt.text, widget.id);
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
        child: SelectableText(
txtedt.text,

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

    TodoApp.updateFirestoreBoolValueHasDocument(id, true);
  }

   getDocumentFromFirebaseStorage(String id) {



    final ref = FirebaseStorage.instance.ref().child('$id.md');

    ref.getDownloadURL().then((val) {
      ref.getDownloadURL().then((value) {
        print(value);
        convertContentsofHtmlUrlToString(value);
      });
    });
    }

  void convertContentsofHtmlUrlToString(String value) {
    var url = Uri.parse(value);
    var client = new HttpClient();
    client.getUrl(url).then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      response.transform(utf8.decoder).listen((contents) {
          txtedt.text = contents;

      });
    });

  }

}




