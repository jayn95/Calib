import 'package:flutter/material.dart';

import '../features/screens/nav.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: NavBar(currentRoute: '/share'),
      ),
      body: const Center(
        child: Text('Share Page Content'),
      ),
    );
  }
}
