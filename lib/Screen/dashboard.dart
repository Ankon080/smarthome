import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthome/style/SmallContainerStyle.dart';
import 'package:smarthome/style/colors.dart';
import 'package:smarthome/style/drawer.dart';
import 'package:smarthome/user_auth/FIrebase_auth/firebaseAuth.dart';
import 'bedroompage.dart';
import 'entranceroom.dart';
import 'kitchenpage.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  String? username;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String? uid = user.uid;
        String? fetchedUsername = await _firebaseAuthService.getUsername(uid);
        setState(() {
          username = fetchedUsername;
        });
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error fetching username: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Mydrawer(username: username, email: _auth.currentUser?.email),

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: GestureDetector(
                          onTap: (){Mydrawer();},
                          child: Container(
                            height: 80,
                            width: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(37,37,37, 50),
                            ),
                            child:IconButton(icon:Icon(Icons.dark_mode,size: 32,color: lightPink,),onPressed: (){  },),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: (){},
                          child: Container(
                            height: 75,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            //  borderRadius: BorderRadius.circular(25),
                              color: Color.fromRGBO(37,37,37, 50),
                            ),
                            child: Icon(Icons.person,size: 32,color: lightPink,),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Column(
                    children: [
                      Text(username != null ? "Hello $username 👋" : "Hello 👋", style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      )),
                      SizedBox(height: 10,),
                      Text("Welcome Back 👋",style: TextStyle(
                        color: Colors.white54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                  SizedBox(height: 0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,top: 20),
                        child: smallContainer(Icons.cloud, "27°C", "Sylhet", "Bangladeesh"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: smallContainer(Icons.devices, "7", "Connected ", "Devices "),

                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: smallContainer(Icons.cloud, "27°C", "Sylhet", "Bangladeesh"),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Container(
                          height: 70,
                          width: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(37,37,37, 50),
                          ),
                          child: Center(
                            child: Text("7",style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Padding(
                        padding: const EdgeInsets.only(right: 130.0),
                        child: Text("Rooms",style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                      TextButton(onPressed: () {  }, child: Text(
                        "see all",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: GestureDetector(
                            onTap: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>kitchenpage()), (route) => false);},
                            child: Container(// TODO: fetch weather report in this container
                              height: 210,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(29),
                                color: Color.fromRGBO(37,37,37, 50),
                                image: new DecorationImage(
                                  image: new AssetImage("assets/kitchen.jpeg"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 150,),
                                  Icon(Icons.kitchen,color: Colors.white,),
                                  Text("Kitchen",style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: GestureDetector(
                            onTap: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>bedroompage()), (route) => false);},
                            child: Container(// TODO: fetch Total connected device
                              height: 210,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(29),
                                color: Color.fromRGBO(37,37,37, 50),
                                image: new DecorationImage(
                                  image: new AssetImage("assets/bed.jpeg"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 150,),
                                  Icon(Icons.bed_sharp,color: Colors.white,),
                                  Text("Bed Room",style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: GestureDetector(
                            onTap: (){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>enterence()), (route) => false);},
                            child: Container(// TODO: fetch weather report in this container from temparature sensor
                              height: 210,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(29),
                                color: Color.fromRGBO(37,37,37, 50),
                                image: new DecorationImage(
                                  image: new AssetImage("assets/gate.jpeg"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 150,),
                                  Icon(Icons.door_front_door_outlined,color: Colors.white,),
                                  Text("Entrance",style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
