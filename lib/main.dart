import 'package:flutter/material.dart';

import 'screens/reviewer.dart'; // Import Login Form

void main() {
  runApp(const Calib());
}

class Calib extends StatelessWidget {
  const Calib({super.key});

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
      initialRoute: '/reviewer', // Set login page as initial route
      routes: {
        '/reviewer': (context) => Reviewer(),
      },
    );
  }
}
