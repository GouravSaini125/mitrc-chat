import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepak_sharma_updates/Utils/Message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyChatScreen extends StatefulWidget {
  const MyChatScreen({Key key, @required this.path, @required this.isAdmin})
      : super(key: key);
  final String path;
  final bool isAdmin;

  @override
  _MyChatState createState() => _MyChatState();
}

class _MyChatState extends State<MyChatScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Hero(
          tag: "appbar",
          child: Material(
            color: Colors.transparent,
            child: const Text(
              'Deepak Sharma Updates',
              style: TextStyle(
                color: Color(0xFFff5e62),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        actions: [
          Image.asset(
            "assets/images/logo.png",
            width: 50.0,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Container(
          child: Column(
            children: <Widget>[
              //Chat list
              Flexible(
                child: StreamBuilder(
                  stream: getStream(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return !snapshot.hasData
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              DocumentSnapshot messages =
                                  snapshot.data.documents[index];
                              return Message(
                                dateTime: getFormattedDate(
                                    messages.data['timestamp']),
                                msg: messages.data["msg"],
                                direction: widget.isAdmin
                                    ? (messages.data["side"] == "left"
                                        ? "right"
                                        : "left")
                                    : messages.data["side"],
                              );
                            },
                          );
                  },
                ),
              ),
              ...(widget.path == "broadcast" && !widget.isAdmin
                  ? []
                  : [
                      Divider(height: 1.0),
                      Container(
                        decoration:
                            BoxDecoration(color: Theme.of(context).cardColor),
                        child: IconTheme(
                          data: IconThemeData(
                              color: Theme.of(context).accentColor),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  child: Icon(
                                    Icons.message,
                                  ),
                                ),
                                Flexible(
                                  child: TextField(
                                    controller: _textController,
                                    decoration: InputDecoration.collapsed(
                                      hintText: "Enter message",
                                    ),
                                    onChanged: (val) => setState(() {}),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                                  width: 48.0,
                                  height: 48.0,
                                  child: IconButton(
                                    disabledColor: Colors.grey,
                                    icon: Icon(
                                      Icons.send,
                                    ),
                                    onPressed: _textController.text.isNotEmpty
                                        ? () => _sendMsg(
                                              context,
                                              _textController.text,
                                            )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ])
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedDate(timestamp) {
    var time = DateTime.parse(timestamp.toDate().toString());
    return '${time.day}-${time.month}-${time.year}  ${time.hour}:${time.minute}';
  }

  void _sendMsg(BuildContext ctx, String msg) {
    if (msg.length == 0) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please Enter text",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      _textController.clear();
      if (widget.path == "broadcast") {
        Firestore.instance.collection("broadcast").add({
          "timestamp": Timestamp.fromDate(DateTime.now()),
          "side": "left",
          "msg": msg
        });
        return;
      }
      Firestore.instance.collection("chats/${widget.path}/msgs").add({
        "timestamp": Timestamp.fromDate(DateTime.now()),
        "side": widget.isAdmin ? "left" : "right",
        "msg": msg
      });
    }
  }

  Stream getStream() {
    if (widget.path == "broadcast")
      return Firestore.instance
          .collection("broadcast")
          .orderBy("timestamp", descending: true)
          .snapshots();

    return Firestore.instance
        .collection("chats/${widget.path}/msgs")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
