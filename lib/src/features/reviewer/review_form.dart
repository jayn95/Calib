import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ReviewForm extends StatefulWidget {
  const ReviewForm({super.key});

  @override
  ReviewFormState createState() => ReviewFormState();
}

class ReviewFormState extends State<ReviewForm> {
  Set<String> selectedTags = {};
  double _uploadProgress = 0;
  final List<String> tags = [
    "BA 234",
    "CC2 206",
    "CC 208",
    "CCS 225",
    "CCS 226",
    "CCS 248",
    "CCS 227"
  ];

  final TextEditingController descriptionController = TextEditingController();
  TextEditingController fileController = TextEditingController();
  PlatformFile? pickedFile; // Store the picked file


  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        pickedFile = result.files.single;
        _uploadProgress = 0; // Reset progress when a new file is picked
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Relative paddings and spacings (similar to study form)
    double horizontalPadding = screenWidth > 800 ? 32.0 : 16.0;
    double verticalSpacing = screenHeight > 800 ? 24.0 : 16.0;
    double buttonHeight = screenHeight > 800 ? 14.0 : 10.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalSpacing),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Subject tags section
            Text(
              'Choose subject tag/s:',
              style: TextStyle(
                fontSize: screenWidth > 400 ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF050315),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: verticalSpacing),

            // Tags
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: tags.map((tag) {
                bool isSelected = selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedTags.add(tag);
                      } else {
                        selectedTags.remove(tag);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFEAD8B1),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Color(0xFF050315) : Color(0xFF050315),
                  ),
                  side: const BorderSide(
                    color: Color(0xFF050315),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: verticalSpacing),

            // Description field
            Text(
              'Description',
              style: TextStyle(
                fontSize: screenWidth > 400 ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF050315),
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: verticalSpacing),

            // Materials field
            Text(
              'Materials (Attach file or link)',
              style: TextStyle(
                fontSize: screenWidth > 400 ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF050315),
              ),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: fileController,
              decoration: InputDecoration(
                hintText: 'Enter link to file',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: pickFile,
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: buttonHeight, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFff9f1c),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.attach_file, color: Colors.white),
                    SizedBox(width: 8.0),
                    Text(
                      'Tap to Attach File',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            if (pickedFile != null)  
              Padding(       
                padding: const EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(
                  value: _uploadProgress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFff9f1c)),
                ),
              ),

            SizedBox(height: verticalSpacing * 1.5),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: buttonHeight),
                      backgroundColor: const Color(0xFFff9f1c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: screenWidth > 800 ? 14.0 : 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: buttonHeight),
                      backgroundColor: const Color(0xFFff9f1c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: screenWidth > 800 ? 14.0 : 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _submitForm() async {
  final User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    print("User not logged in!");
    return;
  }
  if (selectedTags.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select at least one subject tag.')),
    );
    return;
  }

  try {
    String fileURL = fileController.text; 
    int likes = 0; 


    if (pickedFile != null) { // Only upload if a file is picked
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${pickedFile!.name}';
      final storageRef = firebase_storage.FirebaseStorage.instance.ref().child('review_session_files/$fileName');


      // Listen for upload progress
      final uploadTask = storageRef.putData(pickedFile!.bytes!);
      uploadTask.snapshotEvents.listen((snapshot) { // Progress updates
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      }, onError: (error) { // Handle errors 
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload Error: $error')),
          );
        }
        print('Upload Error: $error'); // Print to console for debugging
      });

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL
      fileURL = await storageRef.getDownloadURL();
    }
    await FirebaseFirestore.instance.collection('reviewer_sessions').add({
      'userId': user.uid,
      'userName': user.displayName ?? 'Anonymous',
      'userPhotoURL': user.photoURL ?? '',
      'description': descriptionController.text,
      'tags': selectedTags.toList(),
      'file': fileURL, // Store the download URL or the link
      'timestamp': FieldValue.serverTimestamp(),
      'numOfLikes': likes, 
    });


    if (mounted) {
      descriptionController.clear();
      fileController.clear(); // Clear link field too
      selectedTags.clear();
      setState(() {
        pickedFile = null;
        _uploadProgress = 0; // Reset upload progress
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );
      Navigator.pop(context);
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting review: $e')), // Show the error
      );
    }
    print('Error submitting review: $e');  // Print the error to the console for debugging.
  }
}






  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}
