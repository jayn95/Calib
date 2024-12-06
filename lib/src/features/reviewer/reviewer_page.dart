import 'package:Calib/src/features/reviewer/review_form.dart';
import 'package:Calib/src/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared_features/nav.dart';
import 'reviewer_card.dart';


class Reviewer extends StatefulWidget {
  const Reviewer({super.key});

  @override
  _ReviewerState createState() => _ReviewerState();
}

class _ReviewerState extends State<Reviewer> {
  final Map<String, bool> _categories = Map.from(reviewer_Categories);
    List<String> _selectedCategories = []; // Store selected categories
  

  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onTagSelectionChanged(Map<String, bool> selectedCategories) {
    setState(() {
      _categories.clear();
      _categories.addAll(selectedCategories);
      _selectedCategories = selectedCategories.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
    });
  }

  //mat build sa nav
  void _showReviewForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const ReviewForm(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 3 for large screens, 2 for mobile devices
    int columns = MediaQuery.of(context).size.width > 600 ? 3 : 2;

    double screenWidth = MediaQuery.of(context).size.width;
    double cardSpacing = 16.0; // space between cards
    double screenPadding =
        screenWidth > 1100 ? 300.0 : 32.0; // padding on left and right
    double cardSize =
        (screenWidth - (columns - 1) * cardSpacing - screenPadding) /
            columns; // Adjusted for consistent padding
    cardSize = cardSize.clamp(120.0, double.infinity);

    // // Filter userBoxes based on selected categories
    // final filteredBoxes = selectedCategories.isEmpty ||
    //         selectedCategories.contains('All')
    //     ? userBoxes // Show all cards if 'All' is selected or no category is selected
    //     : userBoxes
    //         .where((box) => selectedCategories.contains(box['category']))
    //         .toList();

    // // Add empty placeholders if necessary to maintain 3 cards per row
    // int itemsToFill = 3 - (filteredBoxes.length % 3);
    // if (itemsToFill != 3) {
    //   filteredBoxes.addAll(List.generate(
    //     itemsToFill,
    //     (index) => <String, dynamic>{},
    //   )); // Empty map as a placeholder
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: NavBar(currentRoute: '/reviewer'),
      ),

      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: LayoutBuilder(               
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Add your Text Here',
                      style: TextStyle(
                        fontSize: constraints.maxWidth > 1000 ? 28 : 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
          const SizedBox(height: 20.0),
          // ReviewerTags(
          //           reviewerCategories: _categories,
          //           onSelectionChanged: _onTagSelectionChanged,
          //         ),
          // Tags with scrolling and arrows
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
            child: Row(
              children: [
                // Left Arrow Button
                IconButton(
                  icon: const Icon(Icons.arrow_left),
                  onPressed: _scrollLeft,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection:
                        Axis.horizontal, // Horizontal scroll direction
                    child: Wrap(
                      spacing: screenWidth > 800
                          ? 20.0
                          : 14.0, // Space between each chip
                      children: [
                        // Add "All" option
                        // InputChip(
                        //   label: Text('All',
                        //       style: TextStyle(
                        //           fontSize: screenWidth > 800 ? 16.0 : 9.0)),
                        //   selected: _selectedCategories.contains('All'),
                        //   selectedColor: Colors.blue.shade100,
                        //   backgroundColor: Colors.white,
                        //   onSelected: (isSelected) {
                        //     setState(() {
                        //       if (isSelected) {
                        //         _selectedCategories = [
                        //           'All'
                        //         ]; // Only 'All' is selected
                        //       } else {
                        //         _selectedCategories.remove(
                        //             'All'); // Remove 'All' if deselected
                        //       }
                        //     });
                        //   },
                        // ),
                        // Category chips
                        ..._categories.keys.map((category) {
                          double tagFontSize = screenWidth > 800 ? 16.0 : 9.0;
                          return InputChip(
                            label: Text(category,
                                style: TextStyle(fontSize: tagFontSize)),
                            selected: _selectedCategories.contains(category),
                            selectedColor: Colors.blue.shade100,
                            backgroundColor: Colors.white,
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  _selectedCategories
                                      .add(category); // Add to the list
                                } else {
                                  _selectedCategories
                                      .remove(category); // Remove from the list
                                }
                              });
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                // Right Arrow Button
                IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: _scrollRight,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
            StreamBuilder<QuerySnapshot>(
              stream: _selectedCategories.isNotEmpty // Check if the list is not empty
                  ? FirebaseFirestore.instance
                      .collection('reviewer_sessions')
                      .where('tags', arrayContainsAny: _selectedCategories)
                      // .orderBy('timestamp', descending: true)
                      .snapshots()
                  : FirebaseFirestore.instance // If empty, get all documents
                      .collection('reviewer_sessions')
                      .orderBy('timestamp', descending: true) // Maintain ordering
                      .snapshots(),




//  stream: FirebaseFirestore.instance
//                     .collection('reviewer_sessions')
//                     .where(
//                       'tags',
//                       arrayContainsAny: _selectedCategories.isNotEmpty
//                           ? _selectedCategories
//                           : null, // Pass null to get all documents if no categories are selected
//                     )
//                     .snapshots(), // Use snapshots()


                    
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator()); // Center the indicator
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No review sessions found.')); // Center the text
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth > 800
                            ? 4
                            : constraints.maxWidth > 500
                                ? 3
                                : 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),

                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        return ReviewerBox(
                        documentId: doc.id,
                        userId: doc['userId'] ?? '', // Provide default value if null
                        userName: doc['userName'] ?? '',
                        userPhotoURL: doc['userPhotoURL'] ?? '',
                        subjectTag: (doc['tags'] as List<dynamic>?)?.join(', ') ?? '', // Handle null and casting
                        description: doc['description'] ?? '',
                        file: doc['file'] ?? '',
                        numOfLikes: doc['numOfLikes'] ?? 0,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReviewForm(context),
        backgroundColor: const Color(0xFF3A6D8C),
        child: const Icon(Icons.add),
      ),
    );
  }
}


class ReviewerTags extends StatelessWidget {
  final Map<String, bool> reviewerCategories;
  final ValueChanged<Map<String, bool>> onSelectionChanged;

  const ReviewerTags({
    super.key,
    required this.reviewerCategories,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      children: reviewerCategories.keys.map((String key) {
        return FilterChip(
          label: Text(key),
          selected: reviewerCategories[key]!,
          onSelected: (bool selected) {
            final newCategories = Map<String, bool>.from(reviewerCategories);
            newCategories[key] = selected;
            onSelectionChanged(newCategories);
          },
          selectedColor: const Color(0xFF3A6D8C),
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: reviewerCategories[key]! ? Colors.white : Colors.black, 
          ),
        );
      }).toList(),
    );
  }
}
