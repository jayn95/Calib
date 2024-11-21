import 'package:flutter/material.dart';
import '../widgets/nav.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: NavBar(currentRoute: '/user_profile'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center( // Centers the entire layout
              child: ConstrainedBox( 
                constraints: BoxConstraints(maxWidth: 1200), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isMobile = constraints.maxWidth < 600;

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
                                  const SizedBox(height: 20),
                                  const Text(
                                    'John Doe',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Web Developer, Flutter Enthusiast',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'john.doe@example.com',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAD8B1),
                                      border: Border.all(
                                          color: Colors.blueGrey.shade200),
                                    ),
                                    child: const Column(
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
                                  const SizedBox(height: 30),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF6A9AB0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 10),
                                          foregroundColor: Colors.white,
                                          minimumSize: const Size(double.infinity,
                                              50), 
                                        ),
                                        child: const Text('Share a reviewer'),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF6A9AB0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 10),
                                          foregroundColor: Colors.white,
                                          minimumSize: const Size(double.infinity,
                                              50),
                                        ),
                                        child: const Text('Look for study group'),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : Center(
                                child: Row(
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
                                    const SizedBox(width: 20),
                                   
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'John Doe',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(
                                            'Web Developer, Flutter Enthusiast',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          const Text(
                                            'john.doe@example.com',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 15),
                                          Container(
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEAD8B1),
                                              border: Border.all(
                                                  color: Colors.blueGrey.shade200),
                                            ),
                                            child: const Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF6A9AB0),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 30,
                                                          vertical: 12),
                                                  foregroundColor: Colors.white,
                                                ),
                                                child:
                                                    const Text('Share a reviewer'),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF6A9AB0),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 30,
                                                          vertical: 12),
                                                  foregroundColor: Colors.white,
                                                ),
                                                child: const Text(
                                                    'Look for study group'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                    const SizedBox(height: 50),
                    Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Activities',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 25),
                        MouseRegion(
                          onEnter: (_) {},
                          onExit: (_) {},
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey.shade200),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(15),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Column(
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
                        const SizedBox(height: 20),
                        MouseRegion(
                          onEnter: (_) {},
                          onExit: (_) {},
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey.shade200),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(15),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Column(
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
                        const SizedBox(height: 20),
                        MouseRegion(
                          onEnter: (_) {},
                          onExit: (_) {},
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey.shade200),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(15),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Column(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
