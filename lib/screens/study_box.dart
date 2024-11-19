import 'package:flutter/material.dart';

class StudyBox extends StatelessWidget {
  final String userName;
  final String locationTag;
  final String description;

  const StudyBox({
    super.key,
    required this.userName,
    required this.locationTag,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeTitle = screenWidth > 600 ? 16 : 14;
    double fontSizeSubtitle = screenWidth > 600 ? 14 : 12;
    double fontSizeDescription = screenWidth > 600 ? 12 : 10;
    double buttonFontSize = screenWidth > 600 ? 14 : 12;
    EdgeInsetsGeometry containerPadding = screenWidth > 600 
        ? const EdgeInsets.all(16) 
        : const EdgeInsets.all(8);

    return Card(
      color: Colors.white, // Set background color to white
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFF001f3f), width: 2), // Add black border here
      ),
      elevation: 3,
      child: Padding(
        padding: containerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    userName[0], // Display the first letter of the userName
                    style: TextStyle(
                      fontSize: fontSizeTitle + 4,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              locationTag,
              style: TextStyle(
                fontSize: fontSizeSubtitle,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: fontSizeDescription,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001f3f),
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth > 600 ? 12 : 8,
                      horizontal: screenWidth > 600 ? 80 : 60, // Extended sides
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13), // Rounded borders
                    ),
                  ),
                  child: Text(
                    'UP FOR IT',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
