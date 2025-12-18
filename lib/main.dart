
import 'package:flutter/material.dart';

void main() {
  runApp(const NesiehApp());
}

class NesiehApp extends StatelessWidget {
  const NesiehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nesieh Manager',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدیریت نسیه'),
      ),
      body: const Center(
        child: Text(
          'پروژه نسیه با موفقیت شروع شد ✅',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
