import 'package:flutter/material.dart';
import 'package:flutter_notes/helper/DbHelper.dart';
import 'package:flutter_notes/helper/User.dart';
import 'package:flutter_notes/Screens/loginForm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'MainPage.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _conuserEmail = TextEditingController();
  final _conuserName = TextEditingController();
  final _conuserPass = TextEditingController();
  var dbHelper;


  @override
  void initState(){
    super.initState();
    dbHelper = DbHelper();
  }



  signUp() async{
    String email = _conuserEmail.text;
    String name = _conuserName.text;
    String pass = _conuserPass.text;

    if(email.isEmpty||name.isEmpty||pass.isEmpty){
      Toast.show("ALL Fields Are Required", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }else{

      User user = User(name,email,pass);

      final prefs = await SharedPreferences.getInstance();
      dbHelper.adduser(user).then((userData) {
        Toast.show("Register Successful!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        prefs.setBool('user', true);
        prefs.setString("email", email);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage(email)), (Route<dynamic> route) => false);

      }).catchError((error) {
        print(error);
        Toast.show("Registration failed!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Form"),
      ),
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
                "Login",
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
                  controller: _conuserName,
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
                    hintText: "Username",
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: _conuserEmail,
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
                    hintText: "E-Mail",
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  controller: _conuserPass,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    prefixIcon: Icon(Icons.password),
                    hintText: "Password",
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
                    "Login",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed:  () => signUp(),
                ),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?  "),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (_) => LoginForm()),
                              (Route<dynamic> route) => false);
                      },
                      child: Text("Sign In", style: TextStyle(color: Colors.red),),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
