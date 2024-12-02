import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ReviewForm extends StatefulWidget {
  const ReviewForm({super.key});

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  Set<String> selectedTags = {};
  final List<String> tags = [
    "BA 234",
    "CC2 206",
    "CC 208",
    "CCS 225",
    "CCS 226",
    "CCS 248",
    "CCS 227"
  ];

  TextEditingController fileController = TextEditingController();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    setState(() {
      fileController.text = result?.files.single.name ?? "No file selected";
    });
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
                color: Colors.black,
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

            // Materials field
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
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: pickFile,
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: buttonHeight, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A6D8C),
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
                      backgroundColor: const Color(0xFF3A6D8C),
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
}
