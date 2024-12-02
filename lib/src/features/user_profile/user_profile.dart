import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared_features/nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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

  // Text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user!.uid).get();
        if (userDoc.exists) {
          setState(() {
            _usernameController.text =
                userDoc['displayName'] ?? user!.displayName ?? '';
            _bioController.text = userDoc['bio'] ?? '';
            _aboutMeController.text = userDoc['aboutMe'] ?? '';
            _profileImageUrl = userDoc['profileImageUrl'] ?? user?.photoURL;
          });
        }
      } catch (e) {
        _showErrorMessage('Error loading user data: $e');
      }
    }
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
        final storageRef =
            _storage.ref().child('profile_images').child('${user!.uid}.jpg');

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

        if (username.isEmpty) {
          _showValidationError('Username cannot be empty');
          return;
        }

        if (username.length < 3) {
          _showValidationError('Username must be at least 3 characters long');
          return;
        }

        if (username.length > 30) {
          _showValidationError('Username cannot exceed 30 characters');
          return;
        }

        // Update Firestore document
        await _firestore.collection('users').doc(user!.uid).update({
          'displayName': username,
          'bio': bio,
          'aboutMe': aboutMe,
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
                _loadUserData();
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildProfileImage(),
        const SizedBox(height: 20),
        _buildProfileHeader(true),
        const SizedBox(height: 5),
        _buildProfileSubtitle(),
        const SizedBox(height: 15),
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
        const SizedBox(height: 20), 
        _buildProfileHeader(false),
        _buildProfileSubtitle(),
        const SizedBox(height: 15),
        _buildBioSection(),
        const SizedBox(height: 15),
        _buildAboutMeSection(),
        const SizedBox(height: 20),
        _buildActionButtons(false),
      ],
    ),
  );
}


  
  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _isEditing ? _pickImage : null,
      child: ClipOval(
        child: _profileImage != null
            ? Image.file(_profileImage!,
                width: 80.0, height: 80.0, fit: BoxFit.cover)
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
    );
  }

  Widget _buildDefaultProfileImage() {
    return Image.asset('assets/images/prof.jpg',
        width: 80.0, height: 80.0, fit: BoxFit.cover);
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
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            )
          : Text(
              _usernameController.text.isNotEmpty
                  ? _usernameController.text
                  : 'No Username',
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
      const SizedBox(width: 10), // Adjust space between username and icon
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

  Widget _buildProfileSubtitle() {
    return Column(
      children: [
        Text(
          "${user!.email}",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBioSection() {
    return _isEditing
        ? TextField(
            controller: _bioController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: null,
          )
        : Text(
            _bioController.text.isNotEmpty
                ? _bioController.text
                : 'No description available',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
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
              color: const Color(0xFFEAD8B1),
              border: Border.all(color: Colors.blueGrey.shade200),
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
                      : 'I am a passionate developer with a strong interest in Flutter and mobile app development.',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
  }

  Widget _buildActionButtons(bool isMobile) {
  void _handleShareReviewer() {
    // TODO: Implement share reviewer functionality
    _showSuccessMessage('Share Reviewer feature coming soon');
  }

  void _handleStudyGroup() {
    // TODO: Implement study group functionality
    _showSuccessMessage('Study Group feature coming soon');
  }

  Widget createButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A9AB0),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        foregroundColor: Colors.white,
        minimumSize:
            isMobile ? const Size(double.infinity, 50) : const Size(150, 50), // Ensure buttons have a fixed width on desktop
      ),
      child: Text(text),
    );
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
