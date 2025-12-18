import 'package:flutter/material.dart';
import '../models/customer.dart';

class AddPurchasePage extends StatelessWidget {
  final Customer customer;

  const AddPurchasePage({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ثبت خرید برای ${customer.name}'),
      ),
      body: const Center(
        child: Text(
          'فرم ثبت خرید (مرحله بعد)',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
