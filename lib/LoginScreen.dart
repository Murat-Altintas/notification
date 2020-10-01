import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:notification/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


 /*
  @override
  void initState() {
    checkUserAuth();
    super.initState();
  }

    checkUserAuth() async {
    try {
      User user = await auth.currentUser;
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print(e);
    }
  }
  */

  signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text).then((authResult) async {
        //register fcm token
        String fcmToken = await firebaseMessaging.getToken();
        User user = authResult.user;

        db.collection("users").doc(user.uid).set({"email": user.email, "fcmToken": fcmToken});

        //for topic
        firebaseMessaging.subscribeToTopic("promotion");
        firebaseMessaging.subscribeToTopic("news");
        //for unsubscribe
        //firebaseMessaging.unsubscribeFromTopic("news");

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      }).catchError((error) => {
            showMessage(title: "Alert!", description: "$error"),
          });
    } else {
      print("Provide email & password pass");
      showMessage(title: "Alert!", description: "Provide details");
    }
  }

  showMessage({title, description}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Dismiss"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Email",
              labelText: "Email",
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Password",
              labelText: "Password",
            ),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          RaisedButton(
              child: Text("Sign In"),
              onPressed: () {
                signIn();
              }),
        ],
      ),
    );
  }
}
