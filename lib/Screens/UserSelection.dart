import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepak_sharma_updates/Screens/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserSelection extends StatelessWidget {
  final String user;

  const UserSelection({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.0,
        ),
        user == "dSharma@admin7"
            ? Container(
                margin: EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: RaisedButton(
                  onPressed: () => _addNum(context),
                  child: Text("Add Number"),
                ),
              )
            : Container(),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => MyChatScreen(
                    path: "broadcast",
                    isAdmin: user == "dSharma@admin7",
                  ),
                ),
              );
            },
            child: Container(
              height: 70.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Color(0xFFff9966), Color(0xFFff5e62)])),
              width: MediaQuery.of(context).size.width - 20,
              child: Center(
                  child: Text(
                "Group",
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              )),
            ),
          ),
        ),
        ...getCards(context),
      ],
    );
  }

  List<Widget> getCards(context) {
    if (user != "dSharma@admin7") {
      return [
        SizedBox(
          height: 20.0,
        ),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => MyChatScreen(
                    path: user,
                    isAdmin: user == "dSharma@admin7",
                  ),
                ),
              );
            },
            child: Hero(
              tag: "appbar",
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 70.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [Color(0xFFff9966), Color(0xFFff5e62)])),
                  width: MediaQuery.of(context).size.width - 20,
                  child: Center(
                      child: Text(
                    "Mr. Deepak Sharma",
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  )),
                ),
              ),
            ),
          ),
        )
      ];
    }

    var query = Firestore.instance.collection("users").getDocuments();

    return [
      FutureBuilder(
        future: query,
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot users = snapshot.data.documents[index];
                return Container(
                    margin: EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => MyChatScreen(
                                path: users.documentID,
                                isAdmin: user == "dSharma@admin7",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 70.0,
                          width: MediaQuery.of(context).size.width - 20,
                          child: Card(
                            elevation: 5.0,
                            child: Center(
                                child: Text(
                              "${users.documentID}\t - ${users.data["name"]}",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            )),
                          ),
                        ),
                      ),
                    ));
              },
            ),
          );
        },
      )
    ];
  }

  void _addNum(ctx) async {
    TextEditingController _ctrl = new TextEditingController();
    await showDialog<String>(
      context: ctx,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _ctrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Number',
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: const Text('Add'),
              onPressed: () async {
                if (_ctrl.text.isEmpty) {
                  Scaffold.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Empty Number",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                  return;
                }

                await Firestore.instance
                    .collection("allowed")
                    .document(_ctrl.text)
                    .setData({"self": true});

                Scaffold.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Number Added",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
                Navigator.pop(ctx);
              })
        ],
      ),
    );
  }
}
