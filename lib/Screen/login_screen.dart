import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smarthome/Screen/ForgotPassword.dart';
import 'package:smarthome/Screen/dashboard.dart';
import 'package:smarthome/user_auth/FIrebase_auth/firebaseAuth.dart';
import 'signupScreen.dart';
import 'package:smarthome/style/colors.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
final FirebaseAuthService _auth = FirebaseAuthService();
class _loginScreenState extends State<loginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Container(
                        child: SizedBox(
                            height: 190,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                              child: Image.asset("assets/logo.png"),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        "Smart Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Smart Way of Living",
                      style: TextStyle(
                        //color: Colors.white,
                        fontSize: 20,
                        color: Color.fromRGBO(174, 175, 175,1 ),
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 327,
                      height: 57,
                      child: TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(96, 96, 96, 40),
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 327,
                      height: 57,
                      child: TextFormField(
                        controller: _passwordController,
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(96, 96, 96, 40),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),

                    Container(
                      width: 327,
                      height: 57,
                      child: ElevatedButton(
                        onPressed: () {_signin();},
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white70),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: lightPink,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            )),
                      ),
                    ),
        
                    SizedBox(height: 10,),
        
                    Container(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't Have an account?",style: TextStyle(
                            color: Color.fromRGBO(174, 175, 175, 100),

                          ),),

                          TextButton(onPressed: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>signupscreen()), (route) => false);}, child: Text("Signup",style: TextStyle(
                            color: Color.fromRGBO(234, 23, 99,1),
                          ),)),
                        ],

                      ),
                    ),
                    Container(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Forgotten Your Password??",style: TextStyle(
                            color: Color.fromRGBO(174, 175, 175, 100),

                          ),),

                          TextButton(onPressed: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen()), (route) => false);}, child: Text("Forgot Password",style: TextStyle(
                            color: Color.fromRGBO(234, 23, 99,1),
                          ),)),
                        ],

                      ),
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
  void _signin()async{

    String email = _emailController.text;
    String password = _passwordController.text;
    User ? user = await _auth.signInWithEmailandPassword(email, password);
    if(user!=null){
        print("Login Succesfull");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>dashboard()), (route) => false);

    }

  }

}
