import 'dart:core';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepak_sharma_updates/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/ChatScreen.dart';
import 'Screens/UserSelection.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deepak Sharma Updates',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.teal,
        primaryColor: Colors.white,
        primaryColorDark: Colors.white,
        fontFamily: 'Gamja Flower',
      ),
      home: Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            title: const Text(
              'Deepak Sharma Updates',
              style: TextStyle(
                color: Color(0xFFff5e62),
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              Image.asset(
                "assets/images/logo.png",
                width: 60.0,
              )
            ]),
        body: FutureBuilder(
          future: getScreen(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future getScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var key = prefs.getString("key");
    if (key == null)
      return LoginScreen();
    else if (key == "dSharma@admin7")
      return UserSelection(
        user: "dSharma@admin7",
      );

    var phone = prefs.getString("phone");

    DocumentSnapshot data =
        await Firestore.instance.collection("users").document(phone).get();

    if (data.data == null) return LoginScreen();

    if (data.data["key"] != key) return LoginScreen();

    return UserSelection(
      user: phone,
    );
  }
}
