import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared_features/nav.dart';

class ProfilePage extends StatefulWidget {
  final String userId; // Add userId parameter

  const ProfilePage({super.key, required this.userId}); // Make it required

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Firebase and service instances
  final User? user = FirebaseAuth.instance.currentUser;
  // final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // State variables
  bool _isEditing = false;
  File? _profileImage;
  String? _profileImageUrl;

  bool get _canEdit {  // Add a getter for edit permission
    return widget.userId == FirebaseAuth.instance.currentUser?.uid;
  }

  // Text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  // final TextEditingController _descriptionController = TextEditingController();

  @override
    void initState() {
    super.initState();
    _loadUserData(widget.userId); // Pass the userId to _loadUserData
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: NavBar(currentRoute: '/user_profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isMobile = constraints.maxWidth < 600;

                      return isMobile
                        ? _buildMobileLayout()
                        : _buildDesktopLayout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

Future<void> _loadUserData(String userId) async {
 // try {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get(); // Use userId here

    if (userDoc.exists) {
      setState(() {
        _usernameController.text = userDoc['displayName'] ?? ''; // No need for user!.displayName
        _bioController.text = userDoc['bio'] ?? '';
        _aboutMeController.text = userDoc['aboutMe'] ?? '';
        _facebookLinkController.text = userDoc['facebookLink'] ?? '';
        _profileImageUrl = userDoc['profileImageUrl'] ?? ''; // No need for user?.photoURL
        _selectedProgram = userDoc['program'];
        _selectedYear = userDoc['year'];
        _selectedSection = userDoc['section'];
      });
      
    } else {
      // Handle the case where the user document doesn't exist
      _showErrorMessage('User not found.');
    }
 //} 
 // catch (e) {
 //   _showErrorMessage('Error loading user data: $e');
 // }
}


  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      await _uploadProfileImage();
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage != null && user != null) {
      try {
        // Upload image to Firebase Storage
        final storageRef = _storage
            .ref()
            .child('profile_images')
            .child('${user!.uid}.jpg');
        
        await storageRef.putFile(_profileImage!);
        final imageUrl = await storageRef.getDownloadURL();

        // Save image URL to Firestore
        await _firestore.collection('users').doc(user!.uid).update({
          'profileImageUrl': imageUrl,
        });

        setState(() {
          _profileImageUrl = imageUrl;
        });

        _showSuccessMessage('Profile image updated successfully');
      } catch (e) {
        _showErrorMessage('Error uploading image: $e');
      }
    }
  }

  Future<void> _saveChanges() async {
    if (user != null) {
      try {
        // Validation
        final username = _usernameController.text.trim();
        final bio = _bioController.text.trim();
        final aboutMe = _aboutMeController.text.trim();
        final facebookLink = _facebookLinkController.text.trim();

        if (username.isEmpty) {
          _showValidationError('Username cannot be empty');
          return;
        }

        // Add validation for new fields if needed
        if (_selectedProgram == null) {
          _showValidationError('Please select a program.');
          return;
        }

        if (_selectedYear == null) {
          _showValidationError('Please select a year level.');
          return;
        }

        if (_selectedSection == null) {
          _showValidationError('Please select a section.');
          return;
        }


        // Update Firestore document
        await _firestore.collection('users').doc(user!.uid).update({
          'displayName': username,
          'bio': bio,
          'aboutMe': aboutMe,
          'facebookLink': facebookLink,
          'program': _selectedProgram,
          'year': _selectedYear,
          'section': _selectedSection,
        });

        // Optional: Update Firebase Auth display name
        await user!.updateDisplayName(username);

        _showSuccessMessage('Profile updated successfully!');
      } catch (e) {
        _showErrorMessage('Error saving changes: ${e.toString()}');
      }
    }
  }


  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Changes'),
          content: const Text('Are you sure you want to save these changes?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _loadUserData(widget.userId);
                setState(() {
                  _isEditing = false;
                });
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _saveChanges();
                Navigator.of(context).pop();
                setState(() {
                  _isEditing = false;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      )
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      )
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      )
    );
  }

 Widget _buildMobileLayout() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      _buildProfileImage(),
      const SizedBox(height: 20),
      _buildProfileHeader(true),
      const SizedBox(height: 5),
      _buildBioSection(),  // Ensure bio section is included
      const SizedBox(height: 30),
      _buildAboutMeSection(),
      const SizedBox(height: 30),
      _buildActionButtons(true),
    ],
  );
}

Widget _buildDesktopLayout() {
  return Center(  
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center the entire column
      crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
      children: [
        _buildProfileImage(),
        const SizedBox(height: 15), 
        _buildProfileHeader(false),
        const SizedBox(height: 10), 
        _buildBioSection(), // Bio section on desktop
        const SizedBox(height: 10),
        _buildAboutMeSection(),
        const SizedBox(height: 30),
        _buildActionButtons(false),
      ],
    ),
  );
}

  Widget _buildProfileImage() {
  return GestureDetector(
    onTap: _isEditing ? _pickImage : null,
    child: Container(
      width: 130.0,
      height: 130.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        border: Border.all(
          color: (Color(0xFFf24c00)), 
          width: 3.0, 
        ),
      ),
      child: ClipOval(
        child: _profileImage != null
            ? Image.file(
                _profileImage!, 
                width: 80.0, 
                height: 80.0, 
                fit: BoxFit.cover,
              )
            : _profileImageUrl != null
                ? Image.network(
                    _profileImageUrl!, 
                    width: 80.0, 
                    height: 80.0, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultProfileImage();
                    },
                  )
                : _buildDefaultProfileImage(),
      ),
    ),
  );
}

Widget _buildDefaultProfileImage() {
  return Container(
    width: 80.0,
    height: 80.0,
    decoration: BoxDecoration(
      shape: BoxShape.circle, 
      border: Border.all(
        color: (Color(0xFFf24c00)), // Border color
        width: 3.0, // Border width
      ),
    ),
    child: ClipOval(
      child: Image.asset(
        'assets/images/prof.jpg',
        width: 80.0,
        height: 80.0,
        fit: BoxFit.cover,
      ),
    ),
  );
}

  Widget _buildProfileHeader(bool isMobile) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,  // Change to center
    children: [
      _isEditing
          ? Expanded(
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            )
          : Text(
              _usernameController.text.isNotEmpty
                  ? _usernameController.text
                  : 'No Name',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
      const SizedBox(width: 10), // Adjust space between username and icon
        if (_canEdit) // Conditionally show the edit button // only current user can see edit
          IconButton(
            icon: _isEditing ? const Icon(Icons.check) : const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _showConfirmationDialog();
                } else {
                  _isEditing = true;
                }
              });
            },
          ),
    ],
  );
}

// Define state variables
String? _selectedProgram;
int? _selectedYear;
String? _selectedSection;
final TextEditingController _facebookLinkController = TextEditingController();

// _buildBioSection with Facebook Link field and dropdowns
Widget _buildBioSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Editable Facebook Link (visible when editing)
 _isEditing
  ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly spaces the dropdowns
      children: [
        // Program Dropdown
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0), // Padding to separate the dropdowns
            child: DropdownButtonFormField<String>(
              value: _selectedProgram,
              decoration: const InputDecoration(
                labelText: 'Program',
                border: OutlineInputBorder(),
              ),
              items: ['BSCS', 'BSIT', 'BSEMC', 'BSIS', 'BLIS'].map((program) {
                return DropdownMenuItem<String>(
                  value: program,
                  child: Text(program),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProgram = value;
                });
              },
            ),
          ),
        ),
        
        // Year Dropdown
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButtonFormField<int>(
              value: _selectedYear,
              decoration: const InputDecoration(
                labelText: 'Year Level',
                border: OutlineInputBorder(),
              ),
              items: List.generate(4, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('${index + 1}'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _selectedYear = value;
                });
              },
            ),
          ),
        ),
        
        // Section Dropdown
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedSection,
              decoration: const InputDecoration(
                labelText: 'Section',
                border: OutlineInputBorder(),
              ),
              items: ['A', 'B'].map((section) {
                return DropdownMenuItem<String>(
                  value: section,
                  child: Text(section),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSection = value;
                });
              },
            ),
          ),
        ),
      ],
    )
  : Text(
      // Display Year, Section, and Program in one line when not editing
      _selectedProgram != null && _selectedYear != null && _selectedSection != null
          ? '$_selectedProgram $_selectedYear $_selectedSection'
          : 'Year and Section', // Placeholder text when no selection
      style: const TextStyle(fontSize: 16, color: Color(0xFF050315)),
    ),
      const SizedBox(height: 5),

      _isEditing
          ? TextField(
              controller: _facebookLinkController,
              decoration: const InputDecoration(
                labelText: 'Facebook Profile Link',
                hintText: 'http://facebook.com/yourprofile',
                border: OutlineInputBorder(),
              ),
              maxLines: null, 
            )
          : InkWell( // Use InkWell for tap functionality
        onTap: () async {
          if (_facebookLinkController.text.isNotEmpty) {
            final Uri url = Uri.parse(_facebookLinkController.text);
            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
              throw Exception('Could not launch $_facebookLinkController.text');
            }
          }
        },
        child: Text(
          _facebookLinkController.text.isNotEmpty
              ? _facebookLinkController.text
              : 'Facebook Link',
          style: TextStyle(
            fontSize: 16,
            color: _facebookLinkController.text.isNotEmpty
                ? Colors.blue // Make clickable link blue
                : const Color(0xFF050315),
            decoration: _facebookLinkController.text.isNotEmpty
                ? TextDecoration.underline // Underline the link
                : null,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}


  Widget _buildAboutMeSection() {
    return _isEditing
      ? TextField(
          controller: _aboutMeController,
          decoration: const InputDecoration(
            labelText: 'About Me',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        )
      : Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFffbf69),
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8)
          ),
          constraints: BoxConstraints(
          minHeight: 150.0,
          minWidth: 500.0,   // Minimum width to ensure container doesn't get too narrow
          maxWidth: 800.0, // Minimum height to prevent the container from shrinking too much
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Me',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _aboutMeController.text.isNotEmpty 
                  ? _aboutMeController.text 
                  : 'Share something about your background skills or interest!',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
  }

  Widget _buildActionButtons(bool isMobile) {
    void _handleShareReviewer() {
      // TODO: Implement share reviewer functionality //
      _showSuccessMessage('Share Reviewer feature coming soon');
    }

    void _handleStudyGroup() {
      // TODO: Implement study group functionality //
      _showSuccessMessage('Study Group feature coming soon');
    }

    Widget createButton(String text, VoidCallback onPressed) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFff9f1c),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          foregroundColor: Color(0xFF050315),
          minimumSize: isMobile 
            ? const Size(double.infinity, 50) 
            : const Size(0, 50),
        ),
        child: Text(text),
      );
    }

     // Only show the buttons when not editing
  if (_isEditing) {
    return SizedBox.shrink(); // Return an empty widget when editing
  }

    return isMobile
      ? Column(
          children: [
            createButton('Share a Reviewer', _handleShareReviewer),
            const SizedBox(height: 12),
            createButton('Look for Study Group', _handleStudyGroup),
          ],
        )
  : Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons in desktop
          children: [
            createButton('Share a Reviewer', _handleShareReviewer),
            const SizedBox(width: 10),
            createButton('Look for Study Group', _handleStudyGroup),
          ],
        );
}

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _aboutMeController.dispose();
    super.dispose();
  }
}