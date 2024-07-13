import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailandPassword(String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;

      // Store additional user information in Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
        });
      }
      return user;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }

  Future<String?> getUsername(String uid) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        // Access 'username' field from snapshot data
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic> or null
        return data?['username'] as String?; // Access 'username' field and cast to String or null
      } else {
        // Document with given UID does not exist
        print("Document does not exist for UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error fetching username: $e");
      return null;
    }
  }


  Future<User?> signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }
}


