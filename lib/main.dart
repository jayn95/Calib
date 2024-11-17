import 'package:flutter/material.dart';

import 'screens/study_page.dart'; // Import Login Form

void main() {
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
      initialRoute: '/study_page', // Set login page as initial route
      routes: {
        '/study_page': (context) => StudyPage(),
      },
    );
  }
}
