import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class NotificationScreen extends StatefulWidget {
  final DocumentSnapshot to;

  NotificationScreen({
    this.to,
  });

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TextEditingController _messageController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  @override
  void initState() {

    fetchUser();
    super.initState();
  }

  fetchUser() async {
    User u = await auth.currentUser;
    setState(() {
      user = u;
    });
  }

  handleInput(String input) {
    print(input);
    db.collection("users").doc(widget.to.id).collection("notifications").add({
      "message": input,
      "title": user.email,
      "date": FieldValue.serverTimestamp(),
    }).then((doc) {
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.to.data()["email"]),
      ),
      body: Column(
        children: [
          Flexible(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Write message",
              ),
              onSubmitted: handleInput(_messageController.text),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              handleInput(_messageController.text);
            },
            child: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
