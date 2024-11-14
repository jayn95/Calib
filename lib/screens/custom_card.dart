import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String name;
  final int numOfLikes;
  final String description;
  final String file;
  final String imagePath;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const CustomCard({
    Key? key,
    required this.name,
    required this.numOfLikes,
    required this.description,
    required this.file,
    required this.imagePath,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isExpanded = false; // Track if the description is expanded
  bool _isLiked = false; // Track if the card is liked

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust card size based on screen width
    double cardWidth = screenWidth > 800 ? 200 : 150;

    // Adjust font sizes based on screen width
    double fontSizeName = screenWidth > 800 ? 16 : 12;
    double fontSizeLikes = screenWidth > 800 ? 12 : 10;
    double fontSizeDescription = screenWidth > 800 ? 12 : 10;
    double fontSizeFile = screenWidth > 800 ? 12 : 10;

    // Set the image size based on screen width
    double imageSize = screenWidth > 800 ? 25 : 20;

    // Adjust the button size based on screen width
    double buttonFontSize = screenWidth > 800 ? 12 : 10;
    EdgeInsetsGeometry buttonPadding = screenWidth > 800
        ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 5);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: widget.margin ?? const EdgeInsets.all(10),
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: cardWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min, // To ensure proper sizing
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name with Image on the left
          Row(
            children: [
              // Image to the left of the name
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  widget.imagePath, // Path to the image asset
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: fontSizeName,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Number of Likes below the name
          Text(
            '${widget.numOfLikes} Likes',
            style: TextStyle(
              fontSize: fontSizeLikes,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),

          // Description (clickable to toggle full text)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: AnimatedCrossFade(
              firstChild: Text(
                widget.description,
                style: TextStyle(
                  fontSize: fontSizeDescription,
                  color: Colors.black87,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                widget.description,
                style: TextStyle(
                  fontSize: fontSizeDescription,
                  color: Colors.black87,
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ),
          const SizedBox(height: 4),

          // File reference
          Text(
            'File: ${widget.file}',
            style: TextStyle(
              fontSize: fontSizeFile,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),

          // Centered Like Button at the bottom
          Center(
            child: SizedBox(
              width: double
                  .infinity, // This makes the button take up the full width
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLiked
                      ? const Color(0xFFEAD8B1)
                      : const Color(
                          0xFF3A6D8C), // Change color based on like status
                  padding: buttonPadding,
                  minimumSize: const Size(double.infinity, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _isLiked
                      ? 'Liked'
                      : 'Like', // Change text based on like status
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: buttonFontSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
