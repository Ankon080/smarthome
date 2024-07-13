import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarthome/style/colors.dart';

Drawer Mydrawer({String? username, String? email}) {
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
            leading: Icon(Icons.image,color: lightPink,),
            title: Text('Upload Image',style: TextStyle(color: Colors.white70,fontSize: 18,fontWeight: FontWeight.bold),),
            onTap: () {
              // Handle the home action
            },
          ),

          ListTile(
            leading: Icon(Icons.logout,color: lightPink,),
            title: Text('Logout',style: TextStyle(color: Colors.white70,fontSize: 18,fontWeight: FontWeight.bold),),
            onTap: () {
              // Handle the logout action
            },
          ),
        ],
      ),
    ),
  );
}
