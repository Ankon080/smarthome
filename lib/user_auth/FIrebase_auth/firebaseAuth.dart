import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailandPassword(String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;


      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print("Error occurred: ${e.message}");

      throw e;
    } catch (e) {
      print("An unknown error occurred: $e");

      throw Exception('An unknown error occurred');
    }
  }

  Future<String?> getUsername(String uid) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        // Access 'username' field from snapshot data
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        return data?['username'] as String?;
      } else {

        print("Document does not exist for UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error fetching username: $e");
      throw Exception('Error fetching username');
    }
  }

  Future<User?> signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Error occurred: ${e.message}");

      throw e;
    } catch (e) {
      print("An unknown error occurred: $e");

      throw Exception('An unknown error occurred');
    }
  }
}
