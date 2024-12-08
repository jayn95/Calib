import 'package:flutter/material.dart';
import 'package:Calib/src/services/auth_service.dart'; // Import for authentication service
import '../../shared_features/nav.dart'; // Import for custom navigation bar
import 'study_1.2_card.dart'; // Import for study session card widget
import 'study_1.3_form.dart'; // Import for study session form widget
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore integration

// Main page for managing study sessions
class StudyPage extends StatefulWidget {
  const StudyPage({super.key}); // Key for widget, useful for testing and tree management

  @override
  _StudyPageState createState() => _StudyPageState(); // Creates the state object for StudyPage
}

class _StudyPageState extends State<StudyPage> {
  // Map to track categories and their selected states
  final Map<String, bool> _scategories = Map.from(study_Categories);
  // List of currently selected categories
  List<String> _selectedCategories = [];

  // Controller to handle horizontal scrolling for category chips
  final ScrollController _scrollController = ScrollController();

  // Scrolls the category chips list to the left by 100 pixels
  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100,
      duration: const Duration(milliseconds: 300), // Smooth animation duration
      curve: Curves.easeInOut, // Smooth easing curve
    );
  }

  // Scrolls the category chips list to the right by 100 pixels
  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100,
      duration: const Duration(milliseconds: 300), // Smooth animation duration
      curve: Curves.easeInOut, // Smooth easing curve
    );
  }

  // // Updates the selected categories and refreshes the UI
  // void _onTagSelectionChanged(Map<String, bool> selectedCategories) {
  //   setState(() {
  //     // Update the entire map with the new selection state
  //     _scategories.clear();
  //     _scategories.addAll(selectedCategories);

  //     // Create a list of selected category names
  //     _selectedCategories = selectedCategories.entries
  //         .where((entry) => entry.value) // Filter only selected entries
  //         .map((entry) => entry.key) // Extract category names
  //         .toList();
  //   });
  // }

  // Opens a bottom sheet with the study form
  void _showStudyForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow sheet to resize based on content
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // Rounded top corners
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom), // Avoid keyboard overlap
              child: const StudyForm(), // Form widget for adding a new study session
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get the width of the current screen for responsive design
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white

      // Custom navigation bar at the top
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // Set AppBar height
        child: NavBar(currentRoute: '/study'), // Pass current route to NavBar
      ),

      // Main content of the page
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(), // Prevent over-scrolling behavior
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Add padding and responsive layout
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
              child: Column(
                children: [
                  const SizedBox(height: 80), // Add vertical spacing
                  Center(
                    child: Text(
                      'Add your Text Here', // Placeholder text
                      style: TextStyle(
                        fontSize: constraints.maxWidth > 1000 ? 28 : 20, // Responsive font size
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Additional spacing

                  // Horizontal list of category chips
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth > 800
                          ? 300.0
                          : 30.0, // Adjust margin based on screen size
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth > 800
                          ? 16.0
                          : 8.0, // Adjust padding based on screen size
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        // Left arrow button to scroll chips
                        IconButton(
                          icon: const Icon(Icons.arrow_left),
                          onPressed: _scrollLeft, // Trigger left scroll function
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController, // Attach the scroll controller
                            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                            child: Wrap(
                              spacing: screenWidth > 800
                                  ? 20.0
                                  : 14.0, // Adjust chip spacing based on screen size
                              children: [
                                // Generate chips for each category
                                ..._scategories.keys.map((category) {
                                  double tagFontSize = screenWidth > 800 ? 16.0 : 9.0; // Responsive font size
                                  return InputChip(
                                    label: Text(category, style: TextStyle(fontSize: tagFontSize)),
                                    selected: _selectedCategories.contains(category),
                                    selectedColor: Colors.blue.shade100, // Background when selected
                                    backgroundColor: Colors.white, // Default background
                                    onSelected: (isSelected) {
                                      setState(() {
                                        // Toggle category selection
                                        if (isSelected) {
                                          _selectedCategories.add(category); // Add to selection
                                        } else {
                                          _selectedCategories.remove(category); // Remove from selection
                                        }
                                      });
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        // Right arrow button to scroll chips
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: _scrollRight, // Trigger right scroll function
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20), // Vertical spacing

                  // StreamBuilder to fetch and display study sessions
                  StreamBuilder<QuerySnapshot>(
                    stream: _selectedCategories.isNotEmpty
                        ? FirebaseFirestore.instance
                        .collection('study_sessions')
                        .where('tags', arrayContainsAny: _selectedCategories) // Filter by selected tags
                        .snapshots()
                        : FirebaseFirestore.instance.collection('study_sessions').snapshots(), // Fetch all sessions if no tags are selected
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong'); // Display error message
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show loading indicator
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('No study sessions found.'); // Handle empty state
                      }

                      // Display sessions in a responsive grid
                      return GridView.builder(
                        shrinkWrap: true, // Adjust to content height
                        physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth > 800
                              ? 4 // 4 columns for wide screens
                              : constraints.maxWidth > 500
                              ? 3 // 3 columns for medium screens
                              : 2, // 2 columns for smaller screens
                          crossAxisSpacing: 20, // Spacing between columns
                          mainAxisSpacing: 20, // Spacing between rows
                          childAspectRatio: 1, // Keep items square
                        ),
                        itemCount: snapshot.data!.docs.length, // Number of items to display
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          return StudyBox(
                            documentId: doc.id, // Pass document ID
                            userId: doc['userId'], // Pass user ID
                            userName: doc['userName'], // Pass user name
                            userPhotoURL: doc['userPhotoURL'], // Pass user profile picture
                            locationTag: doc['tags'].join(', '), // Display tags
                            description: doc['description'], // Display description
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // Floating action button to add a new study session
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStudyForm(context), // Trigger form display
        backgroundColor: const Color(0xFF3A6D8C), // Custom button color
        child: const Icon(Icons.add), // Icon for the button
      ),
    );
  }
}
