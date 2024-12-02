import 'data.dart';
import 'study_box.dart';
import 'studytags.dart';
import 'package:flutter/material.dart';
import '../widgets/nav.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  final Map<String, bool> _scategories = Map.from(studyCategories);

  void _onTagSelectionChanged(Map<String, bool> selectedCategories) {
    setState(() {
      _scategories.clear();
      _scategories.addAll(selectedCategories);
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream:lib/screens/study_page.dart
=======
    // Filter userBoxes based on selected categories
    final filteredBoxes = userBoxes.where((box) {
      // Return true if 'All' is selected or if the box's category is in the selected categories
      return _scategories['All'] == true || _scategories[box['category']] == true;
    }).toList();
>>>>>>> Stashed changes:lib/features/study/study_page.dart

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // Adjust height if needed
          child: NavBar(currentRoute: '/study'), // Pass the current route to the NavBar
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.1),
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    Center(
                      child: Text(
                        'Add your Text Here',
                        style: TextStyle(
                          fontSize: constraints.maxWidth > 1000 ? 28 : 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    StudyTags(
                      studyCategories: _scategories,
                      onSelectionChanged: _onTagSelectionChanged,
                    ),
                    SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth > 800 ? 4 : constraints.maxWidth > 500 ? 3 : 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),
                      itemCount: filteredBoxes.length,
                      itemBuilder: (context, index) {
                        var box = filteredBoxes[index];
                        return StudyBox(
                          userName: box['username'],
                          locationTag: "#${box['category']}",
                          description: box['description'],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
