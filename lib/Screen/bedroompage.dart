import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/Screen/dashboard.dart';
import 'package:smarthome/style/ContainerStyle.dart';
import 'package:smarthome/user_auth/FIrebase_auth/firebaseAuth.dart';
import 'signupScreen.dart';

class bedroompage extends StatefulWidget {
  const bedroompage({super.key});

  @override
  State<bedroompage> createState() => _bedroompageState();
}

final FirebaseAuthService _auth = FirebaseAuthService();

class _bedroompageState extends State<bedroompage> {
  @override
  Widget build(BuildContext context) {
    bool lights = false;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_rounded, color: Colors.white,size: 42,),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>dashboard()), (route) => false);
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 130,
                      child: Padding(padding: const EdgeInsets.fromLTRB(0,
                         20, 0, 0),
                        child: Image.asset("assets/logo.png"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: IconButton(
                        icon: Icon(Icons.person_pin, color: Colors.white,size: 42,),
                        onPressed: () {
                          // Implement your back button functionality
                        },
                      ),
                    ),
                  ),
                ],
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
                  fontSize: 20,
                  color: Color.fromRGBO(174, 175, 175, 1),
                ),
              ),
              SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 10),
                  Mycontainer(myicon: Icons.lightbulb, containerText: "lighting"),
                  Mycontainer(myicon: Icons.lightbulb, containerText: "lighting"),


                  SizedBox(width: 10),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 10),
                  Mycontainer(myicon: Icons.lightbulb, containerText: "lighting"),
                  Mycontainer(myicon: Icons.lightbulb, containerText: "lighting"),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
