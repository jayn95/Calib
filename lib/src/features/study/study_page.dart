import 'package:flutter/material.dart';

import 'package:Calib/src/services/auth_service.dart';
import '../../shared_features/nav.dart';
import 'study_card.dart';
import 'study_form.dart'; 

import 'package:cloud_firestore/cloud_firestore.dart';


class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  final Map<String, bool> _scategories = Map.from(studyCategories);
  List<String> _selectedCategories = []; // Store selected categories

  void _onTagSelectionChanged(Map<String, bool> selectedCategories) {
    setState(() {
      _scategories.clear();
      _scategories.addAll(selectedCategories);
      _selectedCategories = selectedCategories.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
    });
  }

  //mat build sa nav
  void _showStudyForm(BuildContext context) {
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
              child: const StudyForm(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: NavBar(currentRoute: '/study'),
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
                      'Find your study buddy',
                      style: TextStyle(
                        fontSize: constraints.maxWidth > 1000 ? 28 : 20,
                        color: Color(0xFF050315),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  StudyTags(
                    studyCategories: _scategories,
                    onSelectionChanged: _onTagSelectionChanged,
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<QuerySnapshot>(
                    stream: _selectedCategories.isNotEmpty 
                      ? FirebaseFirestore.instance
                          .collection('study_sessions')
                          .where('tags', arrayContainsAny: _selectedCategories)
                          .snapshots()
                      : FirebaseFirestore.instance 
                          .collection('study_sessions')
                          .snapshots(),
                  builder: (context, snapshot) { 
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Text('No study sessions found.');
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
                          return StudyBox(
                            documentId: doc.id,          
                            userId: doc['userId'],    

                            userName: doc['userName'],
                            userPhotoURL: doc['userPhotoURL'],
                            locationTag: doc['tags'].join(', '),
                            description: doc['description'],
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
        onPressed: () => _showStudyForm(context),
        backgroundColor: const Color(0xFFff9f1c),
        child: const Icon(Icons.add),
      ),
    );
  }
}


class StudyTags extends StatelessWidget {
  final Map<String, bool> studyCategories;
  final ValueChanged<Map<String, bool>> onSelectionChanged;

  const StudyTags({
    super.key,
    required this.studyCategories,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      children: studyCategories.keys.map((String key) {
        return FilterChip(
          label: Text(key),
          selected: studyCategories[key]!,
          onSelected: (bool selected) {
            final newCategories = Map<String, bool>.from(studyCategories);
            newCategories[key] = selected;
            onSelectionChanged(newCategories);
          },
          selectedColor: const Color(0xFFff9f1c),
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: studyCategories[key]! ? Colors.white : Color(0xFF050315), 
          ),
        );
      }).toList(),
    );
  }
}
