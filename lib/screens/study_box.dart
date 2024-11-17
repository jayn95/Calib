import 'package:flutter/material.dart';

class StudyBox extends StatelessWidget {
  final String userName;
  final String locationTag;
  final String description;

  const StudyBox({
    Key? key,
    required this.userName,
    required this.locationTag,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(locationTag),
            const SizedBox(height: 4),
            Text(description),
          ],
        ),
      ),
    );
  }
}
