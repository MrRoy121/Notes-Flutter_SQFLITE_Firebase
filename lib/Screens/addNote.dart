import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';


import 'MainPage.dart';
import '../helper/Data.dart';
import '../helper/DbHelper.dart';


class AddNotes extends StatefulWidget {

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {

  final _conuserLoca = TextEditingController();
  final _conuserData = TextEditingController();
  var dbHelper;


  @override
  void initState(){
    super.initState();
    dbHelper = DbHelper();
  }


  addNote() async{
    final prefs = await SharedPreferences.getInstance();
    String loca = _conuserLoca.text;
    String data = _conuserData.text;
    String email = prefs.getString('email') ?? '';
    DateTime now = DateTime.now();
    String time = "${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}";

    if(loca.isEmpty||data.isEmpty){
      Toast.show("ALL Fields Are Required", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }else{

      Data user = Data(email,loca,data,time);

      dbHelper.addData(user).then((userData) {
        Toast.show("Data Added Successfully!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage(email)), (Route<dynamic> route) => false);
      }).catchError((error) {
        print(error);
        Toast.show("Data add failed!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50.0,
              ),
              Text(
                "Add Notes",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30.03),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  controller: _conuserLoca,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    prefixIcon: Icon(Icons.person),
                    hintText: "Location",
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: _conuserData,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    prefixIcon: Icon(Icons.mail),
                    hintText: "Data",
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.only(top: 10.0),
                child: FlatButton(
                  child: Text(
                    "Save Data",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed:  () => addNote(),
                ),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30.0)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
