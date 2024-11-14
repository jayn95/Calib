import 'package:flutter/material.dart';
import 'data.dart';
import 'custom_card.dart';
import '../widgets/nav.dart';

class Reviewer extends StatefulWidget {
  @override
  _ReviewerState createState() => _ReviewerState();
}

class _ReviewerState extends State<Reviewer> {
  Map<String, bool> _categories = Map.from(categories);
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardSize = screenWidth / 3 - 32; // Adjusted for consistent padding

    // Filter userBoxes based on selectedCategory
    final filteredBoxes = selectedCategory == null
        ? userBoxes
        : userBoxes
            .where((box) => box['category'] == selectedCategory)
            .toList();

    // Add empty placeholders if necessary to maintain 3 cards per row
    int itemsToFill = 3 - (filteredBoxes.length % 3);
    if (itemsToFill != 3) {
      filteredBoxes.addAll(List.generate(
        itemsToFill,
        (index) => <String, dynamic>{}, // Empty map as a placeholder
      ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const NavBar(currentRoute: '/reviewer'),
      ),
      body: Column(
        children: [
          SizedBox(height: 36.0),
          Text(
            'Add a Text',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 36.0),
          Wrap(
            spacing: 10.0,
            children: _categories.keys.map((category) {
              return InputChip(
                label: Text(category),
                selected: _categories[category]!,
                selectedColor: Colors.blue.shade100,
                backgroundColor: Colors.white,
                onSelected: (isSelected) {
                  setState(() {
                    _categories.updateAll((key, value) => false);
                    _categories[category] = isSelected;
                    selectedCategory = isSelected ? category : null;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 24.0),
          Expanded(
            child: SingleChildScrollView(
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
