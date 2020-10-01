import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification/LoginScreen.dart';
import 'package:notification/NotificationScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DocumentSnapshot> users;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    fetchUsers();

    showMessage(title, description) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(title),
              content: Text(description),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text("Dismiss"),
                )
              ],
            );
          });
    }

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showMessage("Notification", "$message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        showMessage("Notification", "$message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showMessage("Notification", "$message");
      },
    );

    super.initState();
  }

  fetchUsers() async {
    QuerySnapshot snapshot = await db.collection("users").get();
    setState(() {
      users = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
      ),
      body: Column(
        children: [
          RaisedButton(
            child: Text("Sign Out"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((a) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              });
            },
          ),
          Expanded(
            child: users != null
                ? ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(users[index].data()["email"].toString().substring(0, 1)),
                          ),
                          title: Text(users[index].data()["email"]),
                          onTap: () {
                            print("USERS INDEX SEND START");
                            Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context) => NotificationScreen(
                                    to: users[index],
                                  ),
                                ));
                            print("USERS INDEX COMPLETE");
                          },
                        ),
                      );
                    })
                : CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
