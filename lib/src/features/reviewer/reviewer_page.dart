import 'dart:math';

import 'package:Calib/src/features/reviewer/review_form.dart'; // Import for the review form widget
import 'package:Calib/src/services/auth_service.dart'; // Import for authentication service
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore integration
import 'package:flutter/material.dart'; // Flutter framework imports

import '../../shared_features/nav.dart'; // Import for the navigation bar
import 'reviewer_card.dart'; // Import for the reviewer card widget

// Main page for managing reviewer sessions
class Reviewer extends StatefulWidget {
  const Reviewer({super.key}); // Key for the widget, useful for testing

  @override
  _ReviewerState createState() => _ReviewerState(); // Creates state object
}

class _ReviewerState extends State<Reviewer> {
  // Map to track categories and their selected states
  final Map<String, bool> _categories = Map.from(reviewer_Categories);

  // List of currently selected categories
  List<String> _selectedCategories = [];

  // Controller to handle horizontal scrolling for category chips
  final ScrollController _scrollController = ScrollController();

  // Scrolls the category chips list to the left
  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Scrolls the category chips list to the right
  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Opens a bottom sheet with the review form
  void _showReviewForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow sheet resizing based on content
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)), // Rounded top corners
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Avoid keyboard overlap
              ),
              child: const ReviewForm(), // Form widget for adding a new review
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the number of columns based on screen size
    int columns = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    // Responsive design calculations
    double screenWidth = MediaQuery.of(context).size.width;
    double cardSpacing = 16.0; // Space between cards
    double screenPadding = screenWidth > 1100 ? 300.0 : 32.0; // Side padding
    double cardSize = (screenWidth - (columns - 1) * cardSpacing - screenPadding) / columns;
    cardSize = cardSize.clamp(120.0, double.infinity); // Clamp card size to avoid layout issues

    return Scaffold(
      backgroundColor: Colors.white, // Background color of the screen

      // Navigation bar at the top
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), // AppBar height
        child: NavBar(currentRoute: '/reviewer'), // Custom navigation bar
      ),

      // Main content
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(), // Prevent over-scrolling
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
              child: Column(
                children: [
                  const SizedBox(height: 80), // Spacing at the top
                  Center(
                    child: Text(
                      'Share and Discover', // Placeholder text
                      style: TextStyle(
                        fontSize: constraints.maxWidth > 1000 ? 28 : 20, // Responsive font size
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0), // Additional spacing

                  // Horizontal scrolling list of category chips
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth > 800 ? 300.0 : 30.0, // Adjust based on screen size
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth > 800 ? 16.0 : 8.0, // Adjust padding
                    ),
                    child: Row(
                      children: [
                        // Left arrow button for scrolling
                        IconButton(
                          icon: const Icon(Icons.arrow_left),
                          onPressed: _scrollLeft,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController, // Attach scroll controller
                            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                            child: Wrap(
                              spacing: screenWidth > 800 ? 20.0 : 14.0, // Space between chips
                              children: [
                                // Generate chips for each category
                                ..._categories.keys.map((category) {
                                  double tagFontSize = screenWidth > 800 ? 16.0 : 9.0; // Responsive font size
                                  return InputChip(
                                    label: Text(category, style: TextStyle(fontSize: tagFontSize)),
                                    selected: _selectedCategories.contains(category),
                                    selectedColor: const Color.fromARGB(255, 252, 206, 147), // Selected state background
                                    backgroundColor: Colors.white, // Default background
                                    onSelected: (isSelected) {
                                      setState(() {
                                        // Toggle category selection
                                        if (isSelected) {
                                          _selectedCategories.add(category);
                                        } else {
                                          _selectedCategories.remove(category);
                                        }
                                      });
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        // Right arrow button for scrolling
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: _scrollRight,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0), // Vertical spacing

                  // StreamBuilder to fetch and display reviewer sessions
                  StreamBuilder<QuerySnapshot>(
                    stream: _selectedCategories.isNotEmpty
                        ? FirebaseFirestore.instance
                        .collection('reviewer_sessions')
                        .where('tags', arrayContainsAny: _selectedCategories)
                        .snapshots()
                        : FirebaseFirestore.instance
                        .collection('reviewer_sessions')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong $e'); // Display error message
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show loading indicator
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('No study sessions found.'); // Handle empty state
                      }

                      // Display reviewer sessions in a responsive grid
                      return GridView.builder(
                        shrinkWrap: true, // Adjust to content height
                        physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth > 800
                              ? 4
                              : 1,
                          crossAxisSpacing: 20, // Space between columns
                          mainAxisSpacing: 20, // Space between rows
                          childAspectRatio: 1, // Keep items square
                        ),
                        itemCount: snapshot.data!.docs.length, // Number of items to display
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          return Padding(
                            padding: EdgeInsets.all(screenWidth > 600 ? 12.0 : 6.0), // Reduce padding on mobile
                            child: ReviewerBox(
                            documentId: doc.id, // Pass document ID
                            userId: doc['userId'] ?? '', // Default value for null
                            userName: doc['userName'] ?? '', // User name
                            userPhotoURL: doc['userPhotoURL'] ?? '', // User profile photo
                            subjectTag: (doc['tags'] as List<dynamic>?)?.join(', ') ?? '', // Tags as string
                            description: doc['description'] ?? '', // Review description
                            file: doc['file'] ?? '', // Attached file
                            numOfLikes: doc['numOfLikes'] ?? 0, // Number of likes
                          ),
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

      // Floating action button to add a new review
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReviewForm(context), // Trigger form display
        backgroundColor: const Color(0xFFffbf69), // Custom button color
        child: const Icon(Icons.add), // Plus icon for the button
      ),
    );
  }
}
