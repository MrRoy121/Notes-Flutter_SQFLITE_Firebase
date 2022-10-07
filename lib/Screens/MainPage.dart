import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/Screens/addNote.dart';
import 'package:flutter_notes/Screens/loginForm.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../helper/DbHelper.dart';
import 'onlineNotes.dart';

class MainPage extends StatefulWidget {
  String email;
  MainPage(this.email);
  @override
  State<MainPage> createState() => _MainPageState(email);
}

class _MainPageState extends State<MainPage> {
  var dbHelper;
  String email;
  _MainPageState(this.email);
  List<Map> slist = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    showdata();
  }

  showdata() async {
    slist = await dbHelper.showdata(email);
    setState(() {});
  }

  addNote() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => AddNotes()),
        (Route<dynamic> route) => false);
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('user', false);
    prefs.setString('email', "");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginForm()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        padding: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      FlatButton(
                        child: Text(
                          "Add Note",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => addNote(),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      FlatButton(
                        child: Text(
                          "Online",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          final ConfirmAction action =
                              await _asyncConfirmDialog(context, slist, email);
                          print("Confirm Action $action");
                        },
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                IconButton(
                    onPressed: () => logout(),
                    icon: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ))
              ],
            ),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              child: Container(
                child: slist.length == 0
                    ? Text("No any students to show.")
                    : //show message if there is no any student
                    Column(
                        //or populate list to Column children if there is student data.
                        children: slist.map((stuone) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0)),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          stuone["data_time"],
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      stuone["data_location"],
                                      style: TextStyle(
                                          color: Colors.black26,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      stuone["data"],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ConfirmAction { Cancel, Accept, View }

Future<ConfirmAction> _asyncConfirmDialog(BuildContext context, List<Map> slist, String email) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Data Post to Firebase'),
        content: const Text('Are You Sure You want To Post Data Online?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('View', style: TextStyle(color: Colors.greenAccent),),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_)  {return OnlineNotes(email);}));
            },

          ),
          FlatButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },

          ),
          FlatButton(child: const Text('Post', style: TextStyle(color: Colors.blue),), onPressed: () {
            var dbHelper = DbHelper();
            for(var s in slist){
              FirebaseFirestore.instance.collection('Data').add(s).then((value) => print("User Added"))
                  .catchError((error) => print("Failed to add user: $error"));
            }
            dbHelper.deleteData();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainPage(email)),
                    (Route<dynamic> route) => false);
        }),
        ],
      );
    },
  );
}
