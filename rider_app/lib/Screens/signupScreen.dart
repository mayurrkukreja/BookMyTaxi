import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/Screens/loginScreen.dart';
import 'package:rider_app/Screens/main_screen.dart';
import 'package:rider_app/constants.dart';
import 'package:rider_app/main.dart';

class SignupScreen extends StatelessWidget {
  static const String idScreen = "signup";
  //const SignupScreen({Key? key}) : super(key: key);

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
                height: 50,
              ),
              Text(
                "Rapido",
              ),
              Text(
                "SignUp as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
              ),
              SvgPicture.asset(
                "images/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(
                height: 1.0,
              ),
              TextField(
                controller: nameTextEditingController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    labelText: "Name",
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
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    labelText: "Phone",
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
                    if(nameTextEditingController.text.length < 4)
                    {
                      displayToastMessage("Name must be atleast 3 characters!", context);
                    }
                    else if(!emailTextEditingController.text.contains("@"))
                    {
                      displayToastMessage("Enter valid Email Address!", context);
                    }
                    else if(phoneTextEditingController.text.isEmpty)
                    {
                      displayToastMessage("Phone number is mandatory!", context);
                    }
                    else if(passwordTextEditingController.text.length < 7)
                    {
                      displayToastMessage("Password must be atleast 6 characters", context);
                    }
                    registerNewUser(context);
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
                          "Create Account",
                          style: TextStyle(
                              fontSize: 24.0, fontFamily: "Brand Bold"),
                        ),
                      ))),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: Text("Already a user? Login Here.")),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  registerNewUser(BuildContext context) async
  {
    final User? firebaseUser = (
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text, password: passwordTextEditingController.text
        ).catchError((errMsg){
      displayToastMessage("Error:" + errMsg.toString(), context);
    })).user;


    if(firebaseUser != null) // user created
    {
      //save user info to database
      usersRef.child(firebaseUser.uid);

      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Account created Successfully", context);

      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
    }
    else
    {
    //error
    displayToastMessage("New user account has not been", context);
    }
  }
}

displayToastMessage(String message, BuildContext context)
  {
    Fluttertoast.showToast(msg: message);
  }
