import 'package:flutter/material.dart';
import 'package:flutter_notes/Screens/registerForm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'MainPage.dart';
import '../helper/DbHelper.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _conuserEmail = TextEditingController();
  final _conuserPass = TextEditingController();
  var dbHelper;


  @override
  void initState(){
    super.initState();
    dbHelper = DbHelper();
    sharedPref();
  }


  sharedPref() async{
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getBool('user') ?? false;
    if(user){
      String email = prefs.getString('email') ?? "";
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage(email)), (Route<dynamic> route) => false);
    }
  }
  signIN() async {
    String email = _conuserEmail.text;
    String pass = _conuserPass.text;

    final prefs = await SharedPreferences.getInstance();
    if(email.isEmpty||pass.isEmpty){
      Toast.show("ALL Fields Are Required", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }else{
      await dbHelper.checkUser(email, pass).then((userData) {
        Toast.show("Login Successful!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
         prefs.setBool('user', true);
        prefs.setString("email", email);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage(email)), (Route<dynamic> route) => false);
      }).catchError((error) {
        print(error);
        Toast.show("Login failed!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      });

      Toast.show("Login Successful!", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

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
                  controller: _conuserEmail,
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
                  onPressed: () => signIN(),
                ),
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?  "),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterForm()
                          ),
                        );
                      },
                      child: Text("Sign up", style: TextStyle(color: Colors.red),),
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
