import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewerBox extends StatefulWidget {
  final String userName;

  final String description;
  final String userPhotoURL;
  final String file;
  final int numOfLikes;
  final String documentId;
  final String userId;
  final String subjectTag;



  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const ReviewerBox({
    super.key,
    required this.userName,
    required this.numOfLikes,
    required this.description,
    required this.file,
    required this.userPhotoURL,
    required this.documentId,
    required this.userId, 
    required this.subjectTag,

    this.margin,
    this.padding, 
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomCardState createState() => _CustomCardState();
}





class _CustomCardState extends State<ReviewerBox> {
  bool _isExpanded = false;
  bool _isLiked = false;
  bool _isHovered = false;
  Stream<DocumentSnapshot>? _likeStatusStream; 

      @override
        void initState() {
        super.initState();
        _listenForLikeStatusChanges(); // Check liked status when the widget initializes
    }
    
        @override
      void dispose() {
      _likeStatusStream?.listen(null); // Stop listening in dispose
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    // Adjust card and font sizes based on screen dimensions
    // double cardWidth = screenWidth > 800 ? 200 : 150;
    // double cardHeight = screenHeight > 800 ? 300 : 250;
    double fontSizeLikes = screenWidth > 800 ? 14 : 8;
    double fontSizeDescription = screenWidth > 800 ? 15 : 8;
    double fontSizeFile = screenWidth > 800 ? 15 : 8;
    double buttonFontSize = screenWidth > 800 ? 20 : 8;
    double fontSizeTitle = screenWidth > 600 ? 16 : 14;
    EdgeInsetsGeometry containerPadding =
        screenWidth > 600 ? const EdgeInsets.all(16) : const EdgeInsets.all(8);


    // Adjust button padding
    EdgeInsetsGeometry buttonPadding = screenWidth > 800
        ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 15, vertical: 8);

    // Adjust container and card padding
    // EdgeInsetsGeometry cardPadding = screenWidth > 800
    //     ? const EdgeInsets.all(
    //         20) // Larger padding inside the card for larger screens
    //     : const EdgeInsets.all(16);

    // EdgeInsetsGeometry containerMargin = screenWidth > 800
    //     ? const EdgeInsets.all(
    //         20) // Larger margin around the card for larger screens
    //     : const EdgeInsets.all(5);

    // Adjust container padding/margin for larger screens
// Default padding for smaller screens

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFF001f3f), width: 2),
      ),
      elevation: 3,
      child: Stack(
        children: [
          Padding(
            padding: containerPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                 children: [
                    widget.userPhotoURL.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(widget.userPhotoURL),
                            radius: fontSizeTitle + 2,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: fontSizeTitle + 2,
                            child: Text(
                              widget.userName[0],
                              style: TextStyle(
                                fontSize: fontSizeTitle + 4,
                                color: Colors.black,
                              ),
                            ),
                          ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.userName,
                        style: TextStyle(
                          fontSize: fontSizeTitle,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
          ),
          const SizedBox(height: 8),
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
              onPressed: () async {
                    await _toggleLike();
                      _listenForLikeStatusChanges(); // Refresh like status
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
      ),
                if (widget.userId == FirebaseAuth.instance.currentUser?.uid)
            Positioned(
              top: 8,
              right: 8,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: GestureDetector(
                  onTap: () => _showDeleteConfirmationDialog(context),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: _isHovered ? Colors.red : Colors.grey,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
      ]
      ),
      );
  }


  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this reviewer session?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                 try {
                      await FirebaseFirestore.instance
                         .collection('reviewer_sessions')
                        .doc(widget.documentId)
                        .delete();
                        Navigator.pop(context); 
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('reviewer session deleted!')),
                         );


                } catch (e) {
                   print("Error deleting document: $e");
                  // Show an error message to the user if deletion fails.
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete. Please try again later.')),
                );
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }


  Future<void> _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // Don't do anything if the user is not logged in
    }

    final likesCollection = FirebaseFirestore.instance
        .collection('reviewer_sessions')
        .doc(widget.documentId)
        .collection('likes');

     if (_isLiked) { // If already liked, unlike
      await likesCollection.doc(user.uid).delete();
      await FirebaseFirestore.instance
          .collection('reviewer_sessions')
          .doc(widget.documentId)
          .update({'numOfLikes': FieldValue.increment(-1)});
    } else { // If not liked, like
      await likesCollection.doc(user.uid).set({'liked': true});
      await FirebaseFirestore.instance
          .collection('reviewer_sessions')
          .doc(widget.documentId)
          .update({'numOfLikes': FieldValue.increment(1)});
    }

  }
    void _listenForLikeStatusChanges() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _likeStatusStream = FirebaseFirestore.instance
          .collection('reviewer_sessions')
          .doc(widget.documentId)
          .collection('likes')
          .doc(user.uid)
          .snapshots();

      _likeStatusStream?.listen((snapshot) {
        setState(() {
          _isLiked = snapshot.exists;
        });
      });
    } else {
      // Handle case where user is not logged in (set _isLiked to false)
      setState(() {
        _isLiked = false;
      });
    }
  }

}
