import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/services/firebase_options.dart';
import 'src/features/about/about_page.dart';
import 'src/features/reviewer/reviewer_page.dart';
// import 'features/screens/account_creationform.dart';
import 'package:Calib/src/features/log-in/login_page.dart'; 
import 'src/features/study/study_1.1_page.dart';
import 'src/features/user_profile/user_profile.dart';

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
      title: 'Calib',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: const LoginPage().toString(),
      onGenerateRoute: (settings) {
        // Define all routes here to ensure consistent handling
        switch (settings.name) {
          case '/login':                                    
            return MaterialPageRoute(builder: (_) => const LoginPage());
          // case '/account_creation':
          //   return MaterialPageRoute(builder: (_) => const AccountCreationForm());
          case '/study':
            return MaterialPageRoute(builder: (_) => const StudyPage());
          case '/reviewer':
            return MaterialPageRoute(builder: (_) => const Reviewer()); // mever used
          case '/user_profile':
            String userId = FirebaseAuth.instance.currentUser!.uid; // Or get the ID however you need
            return MaterialPageRoute(builder: (_) => ProfilePage(userId: userId)); 
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutPage());
          default:
            // Return a default route or error page
            return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      },
    );
  }
}
