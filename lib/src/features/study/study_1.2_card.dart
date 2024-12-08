// import 'package:Calib/src/features/study/study_1.3_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Calib/src/features/user_profile/user_profile.dart';
import 'package:url_launcher/url_launcher.dart';


class StudyBox extends StatefulWidget {
  final String userName;
  final String locationTag;
  final String description;
  final String userPhotoURL;
  final String documentId;
  final String userId;

  const StudyBox({
    super.key,
    required this.userName,
    required this.locationTag,
    required this.description,
    required this.userPhotoURL,
    required this.documentId,
    required this.userId,
  });

  @override
  State<StudyBox> createState() => _StudyBoxState();
}

class _StudyBoxState extends State<StudyBox> {
  bool _isHovered = false; 


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeTitle = screenWidth > 600 ? 16 : 14;
    double fontSizeSubtitle = screenWidth > 600 ? 14 : 12;
    double fontSizeDescription = screenWidth > 800 ? 15 : 10;
    double buttonFontSize = screenWidth > 600 ? 14 : 12;
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
                Text(
                  widget.locationTag,
                  style: TextStyle(
                    fontSize: fontSizeSubtitle,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: fontSizeDescription,
                    color: Color(0xFF050315),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _facebookdiabox();
                      },
                      // onPressed: _facebookdiabox,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFff9f1c),
                        padding: EdgeInsets.symmetric(
                          vertical: screenWidth > 600 ? 12 : 8,
                          horizontal: screenWidth > 600 ? 20 : 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'UP FOR IT',
                          style: TextStyle(
                            fontSize: buttonFontSize,
                            color: Colors.white,
                          ),
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
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this study session?"),
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
                      .collection('study_sessions''group_chats')
                      .doc(widget.documentId)
                      .delete();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Study session deleted!')),
                  );
                } catch (e) {
                  print("Error deleting document: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to delete. Please try again later.')),
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

  void _facebookdiabox() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Get the facebookLink of the study session creator
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .get();
        String facebookLink = userSnapshot.get('facebookLink') ?? '';

        // Show the Facebook Link Dialog (passing necessary data)
        _showFacebookLinkDialog(context, facebookLink, widget.userName, widget.userId);



      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error $e')),
        );
      }
    }
  }
  
  void _showFacebookLinkDialog(BuildContext context, String facebookLink, String userName, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$userName\'s Facebook Link'),
          content: facebookLink.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () async {
                        final Uri url = Uri.parse(facebookLink);
                        if (!await launchUrl(url,
                            mode: LaunchMode.externalApplication)) {
                          throw Exception('Could not launch $facebookLink');
                        }
                      },
                      child: Text(
                        facebookLink,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(userId: userId),
                          ),
                        );
                      },
                      child: const Text('Contact them now thru Facebook'),
                    ),
                  ],
                )
              : const Text('No Facebook link available.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

}
