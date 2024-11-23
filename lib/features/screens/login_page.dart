import 'package:Calib/fbase/auth_service.dart'; // Import the AuthService class
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Calib/features/about/about_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final AuthService authService = AuthService();

    /// sets horizontal padding based on screen width. added so there are spaces on both sides (left and right),
    /// else stretch until the very edge and content.
    /// If the screen width is greater than 500 pixels, use 32 pixels of padding
    /// If the screen width is 500 pixels or less, use 16 pixels of padding
    double horizontalPadding = screenWidth > 500 ? 32.0 : 16.0;
    // similar logic lang man sa horizontal but vertical spacing, adjusting based on height.
    double verticalSpacing = screenHeight > 800 ? 32.0 : 24.0;

    /// same with the other two. if screenheight is more than 800 px, button height is 16 px.
    double buttonHeight = screenHeight > 800 ? 16.0 : 12.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 800 ? 800 : screenWidth * 0.9,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo display
                Center(
                  child: Image.asset(
                    'assets/trial.jpg', // This is just a trial image
                    height: 100.0,
                  ),
                ),
                SizedBox(height: verticalSpacing),

                // Page Title
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login to Your Account',
                      style: TextStyle(
                        fontSize: screenWidth > 800 ? 16 : 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Use your WVSU email',
                      style: TextStyle(
                        fontSize: screenWidth > 800 ? 14 : 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                // Continue with Google Button
                OutlinedButton.icon(
                  onPressed: () async {
                    // Handle Google Sign-In using AuthService
                    final user = await authService.signInWithGoogle();
                    if (user != null) {
                      // User signed in successfully, navigate to the next screen or show a message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Welcome, ${user.displayName}')),
                      );
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const AboutPage();
                      }));
                    } else {
                      // If sign-in fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google Sign-In failed')),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: buttonHeight),
                    side: const BorderSide(
                        color: Colors.white), // Border color for Google button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: const Icon(
                    FontAwesomeIcons.google,
                    size: 24.0,
                  ),
                  label: Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: screenWidth > 400 ? 16.0 : 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
