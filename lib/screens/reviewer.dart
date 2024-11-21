import 'package:flutter/material.dart';
import 'data.dart';
import 'custom_card.dart';
import '../widgets/nav.dart';

class Reviewer extends StatefulWidget {
  const Reviewer({super.key});

  @override
  _ReviewerState createState() => _ReviewerState();
}

class _ReviewerState extends State<Reviewer> {
  final Map<String, bool> _categories = Map.from(categories);
  List<String> selectedCategories = []; // List to track selected categories
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

    // Filter userBoxes based on selected categories
    final filteredBoxes = selectedCategories.isEmpty ||
            selectedCategories.contains('All')
        ? userBoxes // Show all cards if 'All' is selected or no category is selected
        : userBoxes
            .where((box) => selectedCategories.contains(box['category']))
            .toList();

    // Add empty placeholders if necessary to maintain 3 cards per row
    int itemsToFill = 3 - (filteredBoxes.length % 3);
    if (itemsToFill != 3) {
      filteredBoxes.addAll(List.generate(
        itemsToFill,
        (index) => <String, dynamic>{},
      )); // Empty map as a placeholder
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: NavBar(currentRoute: '/reviewer'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 36.0),
          const Text(
            'Add a Text',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 36.0),
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
                  icon: Icon(Icons.arrow_left),
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
                        InputChip(
                          label: Text('All',
                              style: TextStyle(
                                  fontSize: screenWidth > 800 ? 16.0 : 9.0)),
                          selected: selectedCategories.contains('All'),
                          selectedColor: Colors.blue.shade100,
                          backgroundColor: Colors.white,
                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                selectedCategories = [
                                  'All'
                                ]; // Only 'All' is selected
                              } else {
                                selectedCategories.remove(
                                    'All'); // Remove 'All' if deselected
                              }
                            });
                          },
                        ),
                        // Category chips
                        ..._categories.keys.map((category) {
                          double tagFontSize = screenWidth > 800 ? 16.0 : 9.0;
                          return InputChip(
                            label: Text(category,
                                style: TextStyle(fontSize: tagFontSize)),
                            selected: selectedCategories.contains(category),
                            selectedColor: Colors.blue.shade100,
                            backgroundColor: Colors.white,
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  selectedCategories
                                      .add(category); // Add to the list
                                } else {
                                  selectedCategories
                                      .remove(category); // Remove from the list
                                }
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                // Right Arrow Button
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: _scrollRight,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var box in filteredBoxes)
                      SizedBox(
                        width: cardSize,
                        height: cardSize,
                        child: box.isNotEmpty
                            ? CustomCard(
                                name: box['username'],
                                numOfLikes: box['likes'],
                                description: box['description'],
                                file: box['file'],
                                imagePath: box['image'],
                              )
                            : Container(), // Empty container as placeholder
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
