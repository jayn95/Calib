import 'package:flutter/material.dart';

import '../review/data.dart';
import '../screens/nav.dart';
import 'study_box.dart';
import 'studytags.dart';

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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0), // Adjust height if needed
          child: NavBar(
              currentRoute: '/study'), // Pass the current route to the NavBar
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.1),
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
                    const SizedBox(height: 20),
                    StudyTags(
                      studyCategories: _scategories,
                      onSelectionChanged: _onTagSelectionChanged,
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
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
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return StudyBox(
                          userName: "User Name $index",
                          locationTag: "#LocationTag",
                          description: "Description",
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
