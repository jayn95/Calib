// lib/services/auth_service.dart

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '963113672836-lmnn1d50eh0vjprhcvnof0v61bh1f500.apps.googleusercontent.com', // Set your web client ID here
  );

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the authenticated user
      return userCredential.user;
    } catch (e) {
      log("Error during Google sign-in: $e");
      return null;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    log("User signed out");
  }
}

