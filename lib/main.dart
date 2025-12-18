import 'package:flutter/material.dart';

import 'ui/customer_list_page.dart';

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
      home: const CustomerListPage(),
    );
  }
}
