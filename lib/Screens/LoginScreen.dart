import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ChatScreen.dart';
import 'UserSelection.dart';

class LoginScreen extends StatelessWidget {
  final _sCtrlName = TextEditingController();
  final _sCtrlPhone = TextEditingController();
  final _fCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Text(
                    "Student Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _sCtrlName,
                    decoration: InputDecoration(
                      hintText: "Enter Your Name",
                      focusedBorder: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _sCtrlPhone,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter Your Phone",
                      focusedBorder: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () => _stuLogin(context),
                    child: Text("Login"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Divider(
              color: Colors.teal,
              height: 10.0,
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    "Faculty Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _fCtrl,
                    decoration: InputDecoration(
                      hintText: "Enter the Code",
                      focusedBorder: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () => _facLogin(context),
                    child: Text("Login"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _stuLogin(BuildContext ctx) async {
    if (_sCtrlName.text.isEmpty || _sCtrlPhone.text.isEmpty) {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            "Name and Phone required",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      var name = _sCtrlName.text, phone = _sCtrlPhone.text;

      DocumentSnapshot data =
          await Firestore.instance.collection("allowed").document(phone).get();

      if (data.data == null) {
        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              "Not Allowed to Login",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
        return;
      }

      DocumentReference dRef =
          Firestore.instance.collection("users").document(phone);

      var rng = new Random();
      var key = "${rng.nextInt(9999)}";
      await dRef.setData({
        "key": key,
        "name": name,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("key", key);
      prefs.setString("phone", phone);

      Navigator.of(ctx).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(
              title: const Text(
                'Deepak Sharma Updates',
                style: TextStyle(
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            body: UserSelection(
              user: phone,
            ),
          ),
        ),
      );
    }
  }

  void _facLogin(BuildContext ctx) async {
    if (_fCtrl.text.isEmpty) {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            "Code required",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else if (_fCtrl.text == "dSharma@admin7") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("key", "dSharma@admin7");

      Navigator.of(ctx).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(
              title: const Text(
                'Deepak Sharma Updates',
                style: TextStyle(
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            body: UserSelection(
              user: "dSharma@admin7",
            ),
          ),
        ),
      );
    } else {
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            "Code Invalid",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
