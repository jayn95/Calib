import 'package:Calib/src/features/study/study_1.1_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.signInWithGoogle();
      
      if (user != null) {
        // Navigate to About Page on successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const StudyPage()),
        );
      } else {
        // Show error snackbar for failed login
        _showErrorSnackBar('Sign-in failed. Please use a WVSU email.');
      }
    } catch (e) {
      // Handle any unexpected errors
      _showErrorSnackBar('An error occurred. Please try again.');
    } finally {
      // Ensure loading state is reset
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing utilities
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adaptive padding and sizing
    final horizontalPadding = screenWidth > 600 ? 32.0 : 16.0;
    final verticalSpacing = screenHeight > 800 ? 32.0 : 24.0;
    final logoHeight = screenWidth > 600 ? 150.0 : 100.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_bg2.png'), 
            opacity: 0.5,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth > 600 ? 500 : screenWidth * 0.9,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // App Logo
                    Center(
                      child: Image.asset(
                        'assets/logo.png', 
                        height: logoHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: verticalSpacing),

                    // Login Title
                    Text(
                      'Welcome to Caleb!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth > 600 ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff050315),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please sign in using your WVSU email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth > 600 ? 16 : 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: verticalSpacing),

                    // Google Sign-In Button
                    _buildGoogleSignInButton(screenWidth),
                    
                    // Loading Indicator
                    if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF24C00)), 
                          ),
                          ),
                          ),


                    // Disclaimer
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        '* Only WVSU email addresses are allowed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Google Sign-In Button Widget
  Widget _buildGoogleSignInButton(double screenWidth) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _handleGoogleSignIn,
      icon: const FaIcon(
        FontAwesomeIcons.google,
        color: Colors.white,
      ),
      label: Text(
        'Sign in with Google',
        style: TextStyle(
          fontSize: screenWidth > 600 ? 16 : 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: (Color(0xFFffb768)),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 17,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 3,
        disabledBackgroundColor: (Color(0xFFffbf69)),
      ),
    );
  }
}
