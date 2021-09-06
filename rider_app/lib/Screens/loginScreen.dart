import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rider_app/Screens/main_screen.dart';
import 'package:rider_app/Screens/signupScreen.dart';
import 'package:rider_app/constants.dart';
import 'package:rider_app/main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                "Rapido",
              ),
              Text(
                "Login as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
              ),
              SvgPicture.asset(
                "images/chat.svg",
                height: size.height * 0.45,
              ),
              SizedBox(
                height: 1.0,
              ),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(fontSize: 20.0),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    )),
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                height: 1.0,
              ),
              TextField(
                controller: passwordTextEditingController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(fontSize: 20.0),
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    )),
                style: TextStyle(fontSize: 22.0),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    if(!emailTextEditingController.text.contains("@"))
                    {
                      displayToastMessage("Enter valid Email Address!", context);
                    }
                    else if(passwordTextEditingController.text.isEmpty)
                    {
                      displayToastMessage("Password must be atleast 6 characters", context);
                    }
                    else
                    {
                      //_firebaseAuth.signOut();
                      loginAndAuthenticateUser(context);
                      //displayToastMessage("User does not exist", context);
                    }
                    loginAndAuthenticateUser(context);
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.deepPurpleAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(color: kPrimaryColor)),
                    ),
                  ),
                  child: Container(
                      height: 40,
                      width: 240,
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 24.0, fontFamily: "Brand Bold"),
                        ),
                      ))),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, SignupScreen.idScreen, (route) => false);
                  },
                  child: Text("New User ? Register Now.")),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMessage("Error:" + errMsg.toString(), context);
    })).user;

    if (firebaseUser != null) // user created
    {
      //save user info to database
      usersRef.child(firebaseUser.uid);
      usersRef
          .child(firebaseUser.uid)
          .once()
          .then((DataSnapshot snap) {
                if (snap.value != null) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainScreen.idScreen, (route) => false);
                  displayToastMessage("Logged in Successfully!", context);
                } else {
                  //error
                  _firebaseAuth.signOut();
                  displayToastMessage("User does not exist", context);
                }
              });
    }
    else
    {
      displayToastMessage("Error cannot Sign In", context);
    }
  }
}
