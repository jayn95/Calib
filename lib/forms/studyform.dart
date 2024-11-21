import 'package:flutter/material.dart';

class StudyForm extends StatefulWidget {
  const StudyForm({super.key});

  @override
  _StudyFormState createState() => _StudyFormState();
}

class _StudyFormState extends State<StudyForm> {
  Set<String> selectedTags = {};
  final List<String> tags = ["CICT Shed", "Coop", "Mini Forest", "Library"];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Relative paddings and spacings
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
            // Choose location tags
            Text(
              'Choose location(s):',
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
                fontSize: screenWidth > 800 ? 16 : 14,
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
                        fontSize: screenWidth > 800 ? 14.0 : 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
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
