import '../fbase/auth_service.dart';  // Import the AuthService class
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final AuthService authService = AuthService();

    double horizontalPadding = screenWidth > 500 ? 32.0 : 16.0;
    double verticalSpacing = screenHeight > 800 ? 32.0 : 24.0;
    double buttonHeight = screenHeight > 800 ? 16.0 : 12.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth > 400 ? 400 : screenWidth * 0.9,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/trial.jpg', // This is just a trial image
                    height: 120.0,
                  ),
                ),
                SizedBox(height: verticalSpacing),
                Text(
                  'Login to Your Account',
                  style: TextStyle(
                    fontSize: screenWidth > 400 ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: verticalSpacing),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: verticalSpacing),
                ElevatedButton(
                  onPressed: () {
                    // Handle login action
                    Navigator.pushReplacementNamed(context, '/study'); // Navigate to StudyPage after login
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: buttonHeight),
                    backgroundColor: const Color(0xFF3A6D8C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: screenWidth > 400 ? 16.0 : 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                OutlinedButton.icon(
                  onPressed: () async {
                    final user = await authService.signInWithGoogle();
                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Welcome, ${user.displayName}')),
                      );
                      Navigator.pushReplacementNamed(context, '/study'); // Navigate to StudyPage after Google sign-in
                    } else {
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
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/account_creation');
                  },
                  child: const Text(
                    "Don't have an account? Sign up here",
                    style: TextStyle(color: Color(0xFF3A6D8C)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
