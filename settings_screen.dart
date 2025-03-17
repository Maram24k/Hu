import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          'إعدادات التطبيق',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
