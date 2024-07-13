
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class enterence extends StatefulWidget {
  const enterence({super.key});

  @override
  State<enterence> createState() => _enterenceState();
}

class _enterenceState extends State<enterence> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        reverse: true,
        child: SafeArea(
          child: Stack(
            children: [

              Column(
                children: [
                  SizedBox(height: 25,),
                  Row(
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Container(
                          height: 80,
                          width: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(37,37,37, 50),
                          ),
                          child: Icon(Icons.person,size: 32,color: Colors.white,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(240, 0, 0, 0),
                        child: Container(
                          height: 75,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color.fromRGBO(37,37,37, 50),
                          ),
                          child: Icon(Icons.notifications,size: 32,color: Colors.white,),
                        ),
                      ),
                    ],
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }


}
