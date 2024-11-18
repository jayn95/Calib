import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'fbase/firebase_options.dart';
import 'screens/account_creation.dart'; // Import Account Creation Form
import 'screens/login.dart'; // Import Login Form


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto', // Set Roboto as the default font
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A6D8C), // Use a seed color for the theme
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login', // Set login page as initial route
      routes: {
        '/login': (context) => const LoginForm(), // Login page route
        '/account_creation': (context) =>
            AccountCreationForm(), // Account creation page route
      },
    );
  }
}
