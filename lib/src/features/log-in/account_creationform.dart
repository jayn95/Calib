// import 'package:flutter/material.dart';

// class AccountCreationForm extends StatefulWidget {
//   const AccountCreationForm({super.key});

//   @override
//   _AccountCreationFormState createState() => _AccountCreationFormState();
// }

// class _AccountCreationFormState extends State<AccountCreationForm> {
//   // Controller for the Description field
//   final TextEditingController _descriptionController = TextEditingController();

//   // Limit the description words
//   String _description = '';
//   int _wordCount = 0;

//   void _updateWordCount(String text) {
//     // Split the text by whitespace and count the words
//     List<String> words = text.trim().split(RegExp(r'\s+'));
//     if (words.isNotEmpty && words[0].isEmpty) {
//       words = [];
//     }

//     setState(() {
//       _wordCount = words.length;
//       _description = text;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     double horizontalPadding = screenWidth > 800 ? 60.0 : 30.0;
//     double verticalSpacing = screenHeight > 800 ? 60.0 : 30.0;
//     double buttonHeight = screenHeight > 800 ? 16.0 : 12.0;

//     double textFontSize = screenWidth > 800 ? 14.0 : 12.0;
//     double titleFontSize = screenWidth > 800 ? 24.0 : 16.0;
//     double inputFontSize = screenWidth > 800 ? 14.0 : 12.0;

//     // Dynamic padding based on screen height
//     double topPadding = screenHeight > 800 ? 100.0 : 40.0;
//     double bottomPadding = screenHeight > 800 ? 100.0 : 40.0;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: horizontalPadding).copyWith(
//             top: topPadding,
//             bottom: bottomPadding,
//           ),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxWidth: screenWidth > 800 ? 800 : screenWidth * 0.7,
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Page Title
//                   Text(
//                     'Create an Account',
//                     style: TextStyle(
//                       fontSize: titleFontSize,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 2.0),

//                   // Username Label and Field
//                   Text(
//                     'Username',
//                     style: TextStyle(
//                       fontSize: textFontSize,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
//                   TextFormField(
//                     style: TextStyle(fontSize: inputFontSize),
//                     decoration: InputDecoration(
//                       hintText: 'Enter Username',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),

//                   // Course and Year Level Label and Field
//                   Text(
//                     'Course and Year Level',
//                     style: TextStyle(
//                       fontSize: textFontSize,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
//                   TextFormField(
//                     style: TextStyle(fontSize: inputFontSize),
//                     decoration: InputDecoration(
//                       hintText: 'Enter Course and Year Level',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),

//                   // Facebook Account Link Label and Field
//                   Text(
//                     'Facebook Account Link',
//                     style: TextStyle(
//                       fontSize: textFontSize,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
//                   TextFormField(
//                     style: TextStyle(fontSize: inputFontSize),
//                     decoration: InputDecoration(
//                       hintText: 'Enter your Facebook profile link',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     keyboardType: TextInputType.url,
//                   ),
//                   const SizedBox(height: 16.0),

//                   // Description Label and Field with word limit
//                   Text(
//                     'Description (Max 30 words)',
//                     style: TextStyle(
//                       fontSize: textFontSize,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8.0),
//                   TextFormField(
//                     controller: _descriptionController,
//                     onChanged: _updateWordCount,
//                     style: TextStyle(
//                       fontSize: inputFontSize,
//                     ),

//                     decoration: InputDecoration(
//                       hintText: 'Describe yourself briefly',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     maxLines: 5, // Allow multiple lines for the description
//                   ),
//                   const SizedBox(height: 8.0),

//                   // Word Count Text
//                   Text(
//                     '$_wordCount/30 words',
//                     style: TextStyle(
//                       color: _wordCount > 30 ? Colors.red : Colors.grey,
//                       fontSize: textFontSize,
//                     ),
//                   ),
//                   SizedBox(height: verticalSpacing),

//                   // Create Account Button
//                   ElevatedButton(
//                     onPressed: _wordCount <= 30
//                         ? () {
//                             // Handle account creation logic
//                           }
//                         : null, // Disable the button if word count exceeds 50
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: buttonHeight),
//                       backgroundColor: const Color(0xFFff9f1c),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     child: Text(
//                       'Create Account',
//                       style: TextStyle(
//                         fontSize: screenWidth > 800 ? 20.0 : 16.0,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),

//                   // Already have an account link
//                   TextButton(
//                     onPressed: () {
//                       // Navigate to login page using routes
//                       Navigator.pushNamed(context, '/login');
//                     },
//                     child: const Text(
//                       'Already have an account?',
//                       style: TextStyle(color: Color(0xFFff9f1c)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
