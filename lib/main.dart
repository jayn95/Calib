import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fbase/firebase_options.dart';
import 'features/about/about_page.dart';
import 'features/review/reviewer_page.dart';
import 'features/screens/account_creationform.dart';
import 'features/screens/login_page.dart';
import 'features/study/study_page.dart';
import 'features/user_profile/user_profile.dart';
import 'screens/share.dart'; // Make sure this import exists

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calib App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3A6D8C),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        // Define all routes here to ensure consistent handling
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginForm());
          case '/account_creation':
            return MaterialPageRoute(builder: (_) => AccountCreationForm());
          case '/study':
            return MaterialPageRoute(builder: (_) => const StudyPage());
          case '/reviewer':
            return MaterialPageRoute(builder: (_) => const Reviewer());
          case '/user_profile':
            return MaterialPageRoute(builder: (_) => const ProfilePage());
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutPage());
          case '/share':
            return MaterialPageRoute(builder: (_) => const SharePage());
          default:
            // Return a default route or error page
            return MaterialPageRoute(builder: (_) => const LoginForm());
        }
      },
    );
  }
}
