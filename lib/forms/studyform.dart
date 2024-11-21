import 'package:flutter/material.dart';

class StudyForm extends StatefulWidget {
  const StudyForm({super.key});

  @override
  _StudyFormState createState() => _StudyFormState();
}

class _StudyFormState extends State<StudyForm> {
  // Track selected tags (locations)
  Set<String> selectedTags = {};

  // List of locations
  final List<String> tags = ["CICT Shed", "Coop", "Mini Forest", "Library"];

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
                  // Choose location tags
                  Text(
                    'Choose location(s):',
                    style: TextStyle(
                      fontSize: screenWidth > 400 ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: verticalSpacing),

                  // Display the tags as choice chips
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
                  SizedBox(
                      height: verticalSpacing *
                          1.5), // Adjust spacing before the submit button

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
                            padding:
                                EdgeInsets.symmetric(vertical: buttonHeight),
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
                          width:
                              16.0), // Space between Cancel and Submit buttons
                      // Submit button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle form submission
                          },
                          style: ElevatedButton.styleFrom(
                            padding:
                                EdgeInsets.symmetric(vertical: buttonHeight),
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
                ]),
          ),
        ),
      ),
    );
  }
}
