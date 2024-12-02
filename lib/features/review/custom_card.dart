import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCard extends StatefulWidget {
  final String name;
  final int numOfLikes;
  final String description;
  final String file;
  final String imagePath;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const CustomCard({
    super.key,
    required this.name,
    required this.numOfLikes,
    required this.description,
    required this.file,
    required this.imagePath,
    this.margin,
    this.padding,
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isExpanded = false; // Track if the description is expanded
  bool _isLiked = false; // Track if the card is liked

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust card and font sizes based on screen dimensions
    double cardWidth = screenWidth > 800 ? 200 : 150;
    double cardHeight = screenHeight > 800 ? 300 : 250;
    double fontSizeName = screenWidth > 800 ? 18 : 10;
    double fontSizeLikes = screenWidth > 800 ? 14 : 8;
    double fontSizeDescription = screenWidth > 800 ? 15 : 8;
    double fontSizeFile = screenWidth > 800 ? 15 : 8;
    double imageSize = screenWidth > 800 ? 30 : 20;
    double buttonFontSize = screenWidth > 800 ? 20 : 8;

    // Adjust button padding
    EdgeInsetsGeometry buttonPadding = screenWidth > 800
        ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 15, vertical: 8);

    // Adjust container and card padding
    // EdgeInsetsGeometry cardPadding = screenWidth > 800
    //     ? const EdgeInsets.all(
    //         20) // Larger padding inside the card for larger screens
    //     : const EdgeInsets.all(16);

    EdgeInsetsGeometry containerMargin = screenWidth > 800
        ? const EdgeInsets.all(
            20) // Larger margin around the card for larger screens
        : const EdgeInsets.all(5);

    // Adjust container padding/margin for larger screens
    EdgeInsetsGeometry containerPadding = screenWidth > 800
        ? const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20) // Increased padding for larger screens
        : const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10); // Default padding for smaller screens

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: widget.margin ?? containerMargin,
      padding: containerPadding,
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
      height: cardHeight,
      child: Column(
        children: [
          // Name with Image on the left
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  widget.imagePath, // Path to the image asset
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: screenWidth > 800 ? 10 : 6),
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: fontSizeName,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth > 800 ? 10 : 4),
          // Number of Likes below the name
          Row(
            children: [
              Text(
                '${widget.numOfLikes} Likes',
                style: TextStyle(
                  fontSize: fontSizeLikes,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth > 800 ? 8 : 4),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(height: screenWidth > 800 ? 8 : 4),

                  // File reference
                  InkWell(
                    onTap: () async {
                      final Uri url = Uri.parse(widget.file);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Could not launch ${widget.file}')),
                        );
                      }
                    },
                    child: Text(
                      'File: ${widget.file}',
                      style: TextStyle(
                        fontSize: fontSizeFile,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Like Button at the bottom
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLiked
                      ? const Color(0xFFEAD8B1)
                      : const Color(0xFF3A6D8C),
                  padding: buttonPadding,
                  minimumSize: const Size(double.infinity, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _isLiked ? 'Liked' : 'Like',
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
