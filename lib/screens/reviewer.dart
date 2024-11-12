import 'dart:io';

import 'package:flutter/material.dart';
import 'data.dart';

class Reviewer extends StatefulWidget {
  @override
  _InputChips createState() => _InputChips();
}

class _InputChips extends State<Reviewer> {
  Map<String, bool> _categories = Map.from(categories);
  List<String> _boxes = List.from(boxes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calib")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    });
                  },
                );
              }).toList(),
            ),
            // SizedBox(height: 8.0),
            // Box for the reviewer
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 75.0,
                mainAxisSpacing: 50.0,
                padding: EdgeInsets.all(90.0),
                childAspectRatio: 0.9,
                children: userBoxes.map((boxData) {
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.black),
                    ),
                    // Details inside the box
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 34,
                          backgroundImage: AssetImage(boxData['image']!),
                        ),
                        SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Username
                              Text(
                                boxData['username']!,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '${boxData['likes']} likes',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
