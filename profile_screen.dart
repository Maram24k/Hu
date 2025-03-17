import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          'صفحة الملف الشخصي',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
