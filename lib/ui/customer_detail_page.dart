import 'package:flutter/material.dart';
import '../models/customer.dart';

class CustomerDetailPage extends StatelessWidget {
  final Customer customer;

  const CustomerDetailPage({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
      ),
      body: const Center(
        child: Text('صفحه جزئیات مشتری'),
      ),
    );
  }
}
