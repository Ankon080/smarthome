import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
 // Make sure this is the path to your login screen
import 'package:smarthome/style/colors.dart';
import 'package:flutter/scheduler.dart';

import '../Screen/login_screen.dart';

Drawer Mydrawer(BuildContext context, {String? username, String? email}) {
  return Drawer(
    child: Container(
      color: Colors.black87,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: lightPink,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: lightPink),
                ),
                SizedBox(height: 10),
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

          ListTile(
            leading: Icon(Icons.logout, color: lightPink),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              try {
                await FirebaseAuth.instance.signOut();
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => loginScreen()),
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
  );
}
