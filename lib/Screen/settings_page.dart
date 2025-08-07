import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:smarthome/style/colors.dart';
import '../Screen/login_screen.dart';

class SettingsPage extends StatelessWidget {
  final String? username;
  final String? email;

  SettingsPage({this.username, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black87,
            child: Column(
              children: [
                Container(
                  color: lightPink,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: lightPink),
                      ),
                      SizedBox(width: 16),
                      Container(
                        height: 90,
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                username ?? 'Username',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                email ?? 'email@example.com',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: Icon(Icons.image, color: lightPink),
                        title: Text(
                          'Upload Image',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // Handle the upload image action
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout, color: lightPink),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => loginScreen()), // Replace with your login screen widget
                                    (route) => false,
                              );
                            });
                          } catch (e) {
                            // Handle sign-out error
                            print('Error signing out: $e');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => loginScreen()), // Replace with your login screen widget
                      (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
