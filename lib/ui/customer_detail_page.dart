import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_debt_service.dart';

class CustomerDetailPage extends StatefulWidget {
  final Customer customer;

  const CustomerDetailPage({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.name),
      ),
      body: const Center(
        child: Text('صفحه جزئیات مشتری'),
      ),
    );
  }
}
