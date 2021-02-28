import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                  ),
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
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            List: <Color>[Color(0xFFff9966), Color(0xFFff5e62)])),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _sCtrlName,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Enter Your Name",
                        // focusedBorder: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            List: <Color>[Color(0xFFff9966), Color(0xFFff5e62)])),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _sCtrlPhone,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Enter Your Phone",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    color: Color(0xFFff5e62),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
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
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            List: <Color>[Color(0xFFff9966), Color(0xFFff5e62)])),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: _fCtrl,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: "Enter the Code",
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    color: Color(0xFFff5e62),
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
