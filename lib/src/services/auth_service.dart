// ignore_for_file: unused_import, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'dart:html' as html; // For web-specific checks

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final Map<String, bool> study_Categories = {
  'CICT Shed' : false,
  'Coop': false,
  'Mini Forest': false,
  'Library': false,
  'Med Gym': false,
  'Quezon hall': false,
  'BINHI': false,
  'Administration building': false,
};

final Map<String, bool> reviewer_Categories = {
  'BA 234': false,
  'CC2 206': false,
  'CC 208': false,
  'CCS 225': false,
  'CCS 226': false,
  'CCS 248': false,
  'CCS 227': false,
};

class AuthService {
  // Singleton pattern for AuthService
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Firebase and Google Sign-In instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: 
      '963113672836-lmnn1d50eh0vjprhcvnof0v61bh1f500.apps.googleusercontent.com', // Web Client ID
    scopes: [
      'email',
      'profile',
    ],
  );

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current authenticated user
  User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Google Sign-In Method
  Future<User?> signInWithGoogle() async {
    try {
      // Platform-specific sign-in handling
      GoogleSignInAccount? googleUser;

      if (kIsWeb) {
        // Web-specific sign-in logic
        googleUser = await _handleWebSignIn();
      } else {
        // Mobile/desktop sign-in logic
        googleUser = await _googleSignIn.signIn();
      }

      // Check if user canceled sign-in
      if (googleUser == null) {
        log('Google Sign-In was canceled');
        return null;
      }

      // Validate WVSU email domain
      if (!_isValidWVSUEmail(googleUser.email)) {
        log('Invalid email domain: ${googleUser.email}');
        await _googleSignIn.signOut(); // Ensure sign-out on invalid email
        return null;
      }

      // Authenticate with Firebase
      return await _firebaseSignInWithGoogle(googleUser);

    } catch (e) {
      log('Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// Web-specific sign-in handling
  Future<GoogleSignInAccount?> _handleWebSignIn() async {
    try {
      // Try silent sign-in first
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      
      // If silent sign-in fails, prompt explicit sign-in
      if (googleUser == null) {
        googleUser = await _googleSignIn.signIn();
      }

      return googleUser;
    } catch (e) {
      log('Web Sign-In Error: $e');
      return null;
    }
  }

  /// Firebase authentication with Google credentials
  Future<User?> _firebaseSignInWithGoogle(GoogleSignInAccount googleUser) async {
    try {
      // Get Google authentication credentials
      final GoogleSignInAuthentication googleAuth = 
        await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = 
        await _auth.signInWithCredential(credential);
      
      final User? user = userCredential.user;

      // Update user in Firestore
      if (user != null) {
        await _updateUserInFirestore(user);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      log('Firebase Authentication Error: ${e.code} - ${e.message}');
      return null;
    }
  }

  /// Update or create user document in Firestore
  Future<void> _updateUserInFirestore(User user) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);
      
      // Check if user document exists
      final docSnapshot = await userRef.get();
      
      final userData = {
        'uid': user.uid,
        'displayName': user.displayName ?? '',
        'email': user.email ?? '',
        // 'aboutMe': '',
        'profileImageUrl': user.photoURL ?? '',
        'emailVerified': user.emailVerified,
        'lastSignInTime': user.metadata.lastSignInTime,
        'creationTime': user.metadata.creationTime,
      };

      // Create or update user document
      if (!docSnapshot.exists) {
        await userRef.set({
          ...userData,
          'bio': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        await userRef.update(userData);
      }
    } catch (e) {
      log('Firestore User Update Error: $e');
      rethrow;
    }
  }

  /// Validate WVSU email domain
  bool _isValidWVSUEmail(String email) {
    return email.toLowerCase().endsWith('@wvsu.edu.ph');
  }

  /// Sign Out Method
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      log('User signed out successfully');
    } catch (e) {
      log('Sign Out Error: $e');
      rethrow;
    }
  }

  /// Reset Password (for email/password authentication)
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      log('Password reset email sent to $email');
    } catch (e) {
      log('Password Reset Error: $e');
      rethrow;
    }
  }

  /// Verify Email
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        log('Verification email sent');
      }
    } catch (e) {
      log('Email Verification Error: $e');
      rethrow;
    }
  }

  /// Get User Claims/Custom Claims
  Future<Map<String, dynamic>?> getUserClaims() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final idTokenResult = await user.getIdTokenResult();
      return idTokenResult.claims;
    } catch (e) {
      log('Get User Claims Error: $e');
      return null;
    }
  }
}