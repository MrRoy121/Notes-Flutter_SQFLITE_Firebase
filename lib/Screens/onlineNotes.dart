import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnlineNotes extends StatefulWidget {
  String email;
  OnlineNotes(this.email);
  @override
  State<OnlineNotes> createState() => _OnlineNotesState(email);
}

class _OnlineNotesState extends State<OnlineNotes> {
  String email;
  _OnlineNotesState(this.email);

  CollectionReference users = FirebaseFirestore.instance.collection('Data');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body:
          Column(
            children: [
          Container(
          margin: EdgeInsets.only(top: 35, left: 20),
      alignment: Alignment.topLeft,
      child: Text(
        "Online Data",
        style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.red),
      ),
    ),
              Container(
                child: StreamBuilder(
                      stream: users.snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                                  itemCount: streamSnapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                DocumentSnapshot stuone = streamSnapshot.data.docs[index];

                                print(stuone["data_email"]);
                                    if (stuone["data_email"].trim()==email.trim()) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                50.0)),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      stuone["data_time"],
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 12),
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
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  stuone["data"],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight
                                                          .bold,
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
                                    }else {
                                      return Text(" ");
                                    }
                                  }
                        );
                        } else {
                          return Text("Document does not exist");
                        }
                      }),
              ),
            ],
          )
    );
  }
}
