import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_debt_service.dart';
import 'add_purchase_page.dart';
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
 late Future<int> _totalDebtFuture;
  @override
void initState() {
  super.initState();

  final customerDebtService = CustomerDebtService();
  _totalDebtFuture =
      customerDebtService.calculateCustomerTotalDebt(widget.customer.id!);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.name),
      ),
      body: Center(
  child: FutureBuilder<int>(
    future: _totalDebtFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }

      if (snapshot.hasError) {
        return const Text(
          'خطا در محاسبه بدهی',
          style: TextStyle(color: Colors.red),
        );
      }

      final totalDebt = snapshot.data ?? 0;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'بدهی کل مشتری',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalDebt تومان',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      );
    },floatingActionButton: FloatingActionButton(
    child: const Icon(Icons.add),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddPurchasePage(
            customer: widget.customer,
          ),
        ),
      );
    },
  ),
);
  ),
),

