import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '963113672836-lmnn1d50eh0vjprhcvnof0v61bh1f500.apps.googleusercontent.com',
  ); // Set your web client ID here (This line is now fixed)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Update or create user data in Firestore (handles null gracefully)
      await _updateUserInFirestore(user);

      return user;
    } on FirebaseAuthException catch (e) {
      log("Error during Google sign-in: ${e.message}");
      //Important:  Re-throw the exception so calling code can handle it (if necessary)
      rethrow;
    } catch (e) {
      log("General Error during Google sign-in: $e");
      //Important:  Re-throw the exception so calling code can handle it (if necessary)
      rethrow;
    }
  }

  Future<void> _updateUserInFirestore(User? user) async {
    if (user == null) return;  //Handle null gracefully

    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final snapshot = await userDoc.get();
    
      // More robust update:  Only update if needed
      if (!snapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'displayName': user.displayName ?? '',
          'email': user.email ?? '',
          'photoURL': user.photoURL ?? '',
          'bio': '', // Initialize bio field
        });
      } else {
        // Update only if necessary to avoid redundant writes
        await userDoc.update({
           'displayName': user.displayName ?? '',
           'email': user.email ?? '',
           'photoURL': user.photoURL ?? '',
        });
      }

    } catch (e) {
      log("Error updating user in Firestore: $e");
      // Important: Re-throw the exception to allow higher-level handling
      rethrow;
    }
  }


  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      log("User signed out");
    } catch (e) {
      log("Error signing out: $e");
      // Important: Re-throw the exception to allow higher-level handling
      rethrow;
    }
  }
}