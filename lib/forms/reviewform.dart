import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ReviewForm extends StatefulWidget {
  const ReviewForm({super.key});

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  // Track selected tags
  Set<String> selectedTags = {};

  // List of tags
  final List<String> tags = [
    "BA 234",
    "CC2 206",
    "CC 208",
    "CCS 225",
    "CCS 226",
    "CCS 248",
    "CCS 227"
  ];

  // Controller for the file or link input
  TextEditingController fileController = TextEditingController();

  // Function to open file picker and select a file
  Future<void> pickFile() async {
    // Open the file picker dialog
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      // Get the selected file's name
      String? fileName = result.files.single.name;
      // Update the controller with the file name
      setState(() {
        fileController.text = fileName;
      });
    } else {
      // If no file was selected, set the text to 'No file selected'
      setState(() {
        fileController.text = "No file selected";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust paddings based on screen size
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
                // Choose subject tags
                Text(
                  'Choose subject tag/s:',
                  style: TextStyle(
                    fontSize: screenWidth > 400 ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),

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
                      selectedColor: const Color(0xFFEAD8B1), // Color when selected
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.black,
                      ),
                      side: const BorderSide(
                        color: Colors.black,
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
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: verticalSpacing),

                // Materials field with clickable file picker
                Text(
                  'Materials (Attach file or link)',
                  style: TextStyle(
                    fontSize: screenWidth > 400 ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                  readOnly: false, // Allow text input for URLs
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: pickFile, // Open file picker when clicked
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: buttonHeight, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6A9AB0),
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
                SizedBox(height: verticalSpacing * 1.5),

                // Submit and Cancel button

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: buttonHeight),
                          backgroundColor: const Color(0xFF3A6D8C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: screenWidth > 400 ? 16.0 : 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 16.0), // Space between Cancel and Submit buttons
                    // Submit button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle form submission
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: buttonHeight),
                          backgroundColor: const Color(0xFF3A6D8C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: screenWidth > 400 ? 16.0 : 14.0,
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
        ),
      ),
    );
  }
}
