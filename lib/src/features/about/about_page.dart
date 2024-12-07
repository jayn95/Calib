import 'package:flutter/material.dart';

import '../../shared_features/nav.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  final List<Map<String, String>> teamMembers = const [
    {
      'imagePath': 'assets/pauline.jpg',
      'role': 'Frontend Developer',
      'name': 'Pauline Joy Bautista',
      'email': 'paulinejoy.bautista@wvsu.edu.ph'
    },
    {
      'imagePath': 'assets/joshua.JPG',
      'role': 'Backend Developer',
      'name': 'Marc Joshua Escueta',
      'email': 'marcjoshua.escueta@wvsu.edu.ph'
    },
    {
      'imagePath': 'assets/ashley.jpg',
      'role': 'Frontend Developer',
      'name': 'Ashley Denise Feliciano',
      'email': 'ashleydenise.feliciano@wvsu.edu.ph'
    },
    {
      'imagePath': 'assets/prince.png',
      'role': 'Backend Developer',
      'name': 'Prince Alexander Malatuba',
      'email': 'princealexander.malatuba@wvsu.edu.ph'
    },
    {
      'imagePath': 'assets/patrick.JPG',
      'role': 'Frontend Developer',
      'name': 'Patrick Joseph Napud',
      'email': 'patrickjoseph.napud@wvsu.edu.ph'
    },
    {
      'imagePath': 'assets/jill.png',
      'role': 'Frontend Developer',
      'name': 'Jill Navarra',
      'email': 'jill.navarra@wvsu.edu.ph'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Thresholds to determine padding, spacing, and font sizes
    double horizontalPadding = screenWidth > 800 ? 60.0 : 30.0;
    double verticalSpacing = screenHeight > 800 ? 32.0 : 30.0;
    double bodyFontSize = screenWidth > 800 ? 16.0 : 12.0;

    // Image size based on screen width (this for About the Calib section)
    double imageWidth = screenWidth > 800 ? 300.0 : 120.0;
    double imageHeight = screenWidth > 800 ? 200.0 : 180.0;

    double horizontalGap = 24.0; // Space between containers horizontally
    double verticalGap = 24.0; // Space between containers vertically

    // Text style based on screen size
    TextStyle bodyTextStyle = TextStyle(
      fontSize: bodyFontSize,
      color: Color(0xFF050315),
      height: 1.2,
    );

    return Scaffold(
      backgroundColor: Color(0xfffbfbfe),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: NavBar(currentRoute: '/about'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'assets/aboutbanner2.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: verticalSpacing),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xffffb768),
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png', // will be changed if there is logo already
                          width: imageWidth,
                          height: imageHeight,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Text(
                            'Calib is a web platform designed to enhance the academic experience of students at West Visayas State University. Created by third-year Computer Science students, it enables Taga-Wests to share and access review materials, find study partners, and join study groups. Through this platform, our goal is to build a supportive learning community where taga-wests can collaborate, share knowledge, and help each other succeed in their academic journey.',
                            style: bodyTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    top: -20.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFffb768),
                        border: Border.all(color: Colors.black),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'About Calib',
                        style: TextStyle(
                          color: Color(0xFF050315),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: verticalSpacing),
              _buildSectionContainer(
                title: 'Meet the Team',
                titlePosition: 'right',
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double itemWidth = screenWidth > 800 ? 200.0 : 130.0;
                    (constraints.maxWidth / (itemWidth + horizontalGap))
                        .floor();

                    return Wrap(
                      spacing: horizontalGap,
                      runSpacing: verticalGap,
                      alignment: WrapAlignment.center,
                      children: teamMembers
                          .map((member) => _teamProfile(
                                imagePath: member['imagePath']!,
                                role: member['role']!,
                                name: member['name']!,
                                email: member['email']!,
                                bodyTextStyle: bodyTextStyle,
                              ))
                          .toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required Widget child,
    required String titlePosition,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xffff9f1c),
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(titlePosition == 'right' ? 8.0 : 0),
              topRight: Radius.circular(titlePosition == 'left' ? 8.0 : 0),
              bottomLeft: const Radius.circular(8.0),
              bottomRight: const Radius.circular(8.0),
            ),
          ),
          child: child,
        ),
        Positioned(
          left: titlePosition == 'left' ? 0.0 : null,
          right: titlePosition == 'right' ? 0.0 : null,
          top: -20.0,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: const Color(0xFFff9f1c),
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF050315),
                fontSize: 18.0, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _teamProfile({
    required String imagePath,
    required String role,
    required String name,
    required String email,
    required TextStyle bodyTextStyle,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final containerHeight = screenWidth > 800 ? 300.0 : 200.0;
      final containerWidth = screenWidth > 800 ? 300.0 : 130.0;
      final profileImageSize = screenWidth > 800 ? 120.0 : 80.0;

      return Container(
  height: containerHeight,
  width: containerWidth,
  decoration: BoxDecoration(
    color: Colors.white, // Background color
    border: Border.all(color: Colors.black), // Border color
    borderRadius: BorderRadius.circular(8.0), // Border radius for rounded corners
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1), // Shadow color with transparency
        offset: Offset(0, 4), 
        blurRadius: 4.0, 
        spreadRadius: 1.0, 
      ),
    ],
  ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: profileImageSize,
              height: profileImageSize,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                imagePath,
                width: profileImageSize,
                height: profileImageSize,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              role,
              style: bodyTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Text(
              name,
              style: bodyTextStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: bodyTextStyle.fontSize! * 0.875,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Text(
              email,
              style: bodyTextStyle.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: bodyTextStyle.fontSize! * 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    });
  }
}
