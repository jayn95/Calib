import 'package:flutter/material.dart';
import '../widgets/nav.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
       return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const NavBar(currentRoute: '/user_profile'),
      ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isMobile = constraints.maxWidth < 600;

                    // Use Column for mobile (stacked layout) and Row for larger screens (side-by-side)
                    return isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'assets/profile_image.jpg',
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'John Doe',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Web Developer, Flutter Enthusiast',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'john.doe@example.com',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 15),
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEAD8B1),
                                  border: Border.all(color: Colors.blueGrey.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'About Me',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'I am a passionate developer with a strong interest in Flutter and mobile app development.',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Share a reviewer'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF6A9AB0),
                                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                      foregroundColor: Colors.white,
                                      minimumSize: Size(double.infinity, 50), // Full-width button
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Look for study group'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF6A9AB0),
                                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                      foregroundColor: Colors.white,
                                      minimumSize: Size(double.infinity, 50), // Full-width button
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'assets/profile_image.jpg',
                                  width: 80.0,
                                  height: 80.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 20),
                              // Column inside Expanded to take available space
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'John Doe',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Web Developer, Flutter Enthusiast',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'john.doe@example.com',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFEAD8B1),
                                        border: Border.all(color: Colors.blueGrey.shade200),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'About Me',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'I am a passionate developer with a strong interest in Flutter and mobile app development.',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Share a reviewer'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF6A9AB0),
                                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Text('Look for study group'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF6A9AB0),
                                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                  },
                ),
                SizedBox(height: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 25),
                    MouseRegion(
                      onEnter: (_) {},
                      onExit: (_) {},
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'POSTS',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'I am a passionate developer with a strong interest in Flutter and mobile app development.',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    MouseRegion(
                      onEnter: (_) {},
                      onExit: (_) {},
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LIKED',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'I am a passionate developer with a strong interest in Flutter and mobile app development.',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    MouseRegion(
                      onEnter: (_) {},
                      onExit: (_) {},
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GROUPS',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'I am a passionate developer with a strong interest in Flutter and mobile app development.',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
