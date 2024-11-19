import 'package:flutter/material.dart';

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
          selectedColor: const Color(0xFF3A6D8C),
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: studyCategories[key]! ? Colors.white : Colors.black, // Text color changes based on selection
          ),
        );
      }).toList(),
    );
  }
}
