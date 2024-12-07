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
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<ReviewerBox> {
  bool _isExpanded = false;
  bool _isLiked = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _checkLikedStatus(); // Check liked status when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeLikes = screenWidth > 800 ? 16 : 14; // Increased font size for like count
    double fontSizeDescription = screenWidth > 800 ? 15 : 10;
    double fontSizeFile = screenWidth > 800 ? 15 : 8;
    double buttonFontSize = screenWidth > 800 ? 30 : 22; // Increased size for like button
    double fontSizeTitle = screenWidth > 600 ? 16 : 14;
    EdgeInsetsGeometry containerPadding =
        screenWidth > 600 ? const EdgeInsets.all(16) : const EdgeInsets.all(8);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFF050315)),
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
                                color: Color(0xFF050315),
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

                // Description with expand/collapse functionality
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
                        color: Color(0xFF050315),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    secondChild: Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: fontSizeDescription,
                        color: Color(0xFF050315),
                      ),
                    ),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ),
                SizedBox(height: screenWidth > 800 ? 8 : 4),

                // File reference with file icon only (no URL displayed)
                widget.file.isNotEmpty
                    ? InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse(widget.file);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Could not launch ${widget.file}')),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.attach_file, color: Colors.blue),
                            const SizedBox(width: 5),
                            Text(
                              'File',
                              style: TextStyle(
                                fontSize: fontSizeFile,
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),

                // Spacer to push the like icon to the bottom
                const Spacer(),
              ],
            ),
          ),

          // Like Icon and Count - Centered at the bottom inside a container
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                width: screenWidth * 0.12, // Make the container wider
                decoration: BoxDecoration(
                  color: Color(0xffff9f1c).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _toggleLike,
                      icon: Icon(
                        _isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                        color: _isLiked ? Colors.white : Colors.white,
                        size: buttonFontSize, // Increased size for like button
                      ),
                    ),
                    Text(
                      '${widget.numOfLikes}',
                      style: TextStyle(
                        fontSize: fontSizeLikes, // Increased font size for like count
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Delete button only for the current user's post
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
        ],
      ),
    );
  }

  Future<void> _checkLikedStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final likesDoc = await FirebaseFirestore.instance
          .collection('reviewer_sessions')
          .doc(widget.documentId)
          .collection('likes')
          .doc(user.uid)
          .get();

      setState(() {
        _isLiked = likesDoc.exists;
      });
    }
  }

  Future<void> _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final likesCollection = FirebaseFirestore.instance
        .collection('reviewer_sessions')
        .doc(widget.documentId)
        .collection('likes');

    setState(() {
      _isLiked = !_isLiked;
    });

    if (_isLiked) {
      await likesCollection.doc(user.uid).set({'liked': true});
      await FirebaseFirestore.instance.collection('reviewer_sessions').doc(widget.documentId).update({
        'numOfLikes': FieldValue.increment(1),
      });
    } else {
      await likesCollection.doc(user.uid).delete();
      await FirebaseFirestore.instance.collection('reviewer_sessions').doc(widget.documentId).update({
        'numOfLikes': FieldValue.increment(-1),
      });
    }
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

  // Add restriction to not allow submission if no file or link is provided
  bool get isMaterialValid => widget.file.isNotEmpty;
}
