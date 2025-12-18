import 'package:flutter/material.dart';
import '../services/customer_debt_service.dart';
import '../models/customer.dart';
import 'add_customer_page.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final CustomerDebtService _debtService = CustomerDebtService();

  Future<List<Map<String, dynamic>>> _loadCustomers() async {
    return await _debtService.getCustomersWithDebt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لیست مشتریان')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطا: ${snapshot.error}'));
          } else {
            final customers = snapshot.data ?? [];
            if (customers.isEmpty) {
              return const Center(child: Text('هیچ مشتری ثبت نشده است'));
            }
            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return ListTile(
                  title: Text(customer['name']),
                  subtitle: Text('بدهی: ${customer['totalDebt']} ریال'),
                onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CustomerDetailPage(
        customer: customer,
      ),
    ),
  );
},

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCustomerPage(),
            ),
          );
          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
