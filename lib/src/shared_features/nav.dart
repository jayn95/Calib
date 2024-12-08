import 'package:Calib/src/features/reviewer/reviewer_page.dart';
import 'package:Calib/src/services/auth_service.dart';

import 'package:Calib/src/features/about/about_page.dart';
import 'package:Calib/src/features/log-in/login_page.dart';
import 'package:Calib/src/features/study/study_1.1_page.dart';
import 'package:Calib/src/features/user_profile/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String currentRoute;
  final AuthService _authService = AuthService();

  NavBar({
    super.key,
    required this.currentRoute,
  });

  void signOutAndNavigateToLogin(BuildContext context) async {
    await _authService.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have successfully signed out.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const LoginPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double logoSize = constraints.maxWidth > 800 ? 40.0 : 30.0;
                return Image.asset(
                  'assets/logo.png', 
                  height: logoSize,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavButton(context, 'Reviewer', '/reviewer', Icons.reviews_rounded),
              _buildNavButton(context, 'Study', '/study', Icons.book),
              _buildNavButton(context, 'About', '/about', Icons.info),
              _buildNavButton(context, 'Profile', '/user_profile', Icons.person),
              _buildLogoutButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    final isActive = currentRoute == route;
    final screenWidth = MediaQuery.of(context).size.width;
    final showIcon = screenWidth <= 800;
    final fontSize = screenWidth > 800 ? 16.0 : 18.0;
    final buttonWidth = screenWidth > 800 ? 120.0 : 50.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: buttonWidth,
        child: TextButton(
          onPressed: () {
            if (!isActive) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    switch (route) {
                      case '/reviewer':
                        return const Reviewer(); 
                      case '/login':
                        return const LoginPage();
                      case '/study':
                        return const StudyPage();
                      case '/about':
                        return const AboutPage();
                      case '/user_profile':
                          // Get the current user's ID:
                        String? userId = FirebaseAuth.instance.currentUser?.uid;
                        if (userId != null) {
                            return ProfilePage(userId: userId);
                          } else {
                            // User is not logged in. Navigate to login page or handle as needed.
                            return const LoginPage(); // Or another appropriate page
                        }
                      default:
                        return const LoginPage();
                    }
                  },
                ),
              );
            }
          },
          style: TextButton.styleFrom(
            backgroundColor:
                isActive ? const Color(0xFFff9f1c) : Colors.transparent,
            foregroundColor: isActive ? Colors.white : Color(0xFF050315),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: showIcon
              ? Icon(icon, size: fontSize)
              : Text(title, style: TextStyle(fontSize: fontSize)),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showIcon = screenWidth <= 800;
    final fontSize = screenWidth > 800 ? 16.0 : 18.0;
    final buttonWidth = screenWidth > 800 ? 120.0 : 50.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: buttonWidth,
        child: ElevatedButton(
          onPressed: () => signOutAndNavigateToLogin(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFf24c00),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: showIcon
              ? Icon(Icons.logout, size: fontSize)
              : Text('Log Out', style: TextStyle(fontSize: fontSize)),
        ),
      ),
    );
  }
}
