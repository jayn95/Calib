import 'package:Calib/screens/data.dart';
import 'package:Calib/screens/study_box.dart';
import 'package:Calib/screens/studytags.dart';
import 'package:flutter/material.dart';


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
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white, // Set the background color to white here
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Center(
                child: Text(
                  'Add your Text Here',
                  style: TextStyle(
                    fontSize: screenWidth > 1000 ? 28 : 20,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: screenWidth > 800 ? 4 : screenWidth > 500 ? 3 : 2,
                  crossAxisSpacing: 50,
                  mainAxisSpacing: 50,
                  childAspectRatio: 1,
                  children: List.generate(9, (index) {
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: StudyBox(
                        userName: "User Name $index",
                        locationTag: "#LocationTag",
                        description: "Description",
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
