
import 'package:flutter/material.dart';

import 'package:smarthome/user_auth/FIrebase_auth/firebaseAuth.dart';
import 'signupScreen.dart';

class kitchenpage extends StatefulWidget {
  const kitchenpage({super.key});

  @override
  State<kitchenpage> createState() => _kitchenpageState();
}
TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
final FirebaseAuthService _auth = FirebaseAuthService();
class _kitchenpageState extends State<kitchenpage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                        height: 190,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                          child: Image.asset("assets/logo.png"),
                        )),
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
