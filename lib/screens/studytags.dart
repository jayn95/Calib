import 'package:flutter/material.dart';

class StudyTags extends StatelessWidget {
  final Map<String, bool> categories;
  final ValueChanged<Map<String, bool>> onSelectionChanged;

  const StudyTags({
    Key? key,
    required this.categories,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      children: categories.keys.map((String key) {
        return FilterChip(
          label: Text(key),
          selected: categories[key]!,
          onSelected: (bool selected) {
            final newCategories = Map<String, bool>.from(categories);
            newCategories[key] = selected;
            onSelectionChanged(newCategories);
          },
        );
      }).toList(),
    );
  }
}
