import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../repositories/customer_repository.dart';
import '../services/customer_debt_service.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final CustomerRepository _customerRepository =
      CustomerRepository();
  final CustomerDebtService _debtService =
      CustomerDebtService();

  late Future<List<Customer>> _customersFuture;

  @override
  void initState() {
    super.initState();
    _customersFuture = _customerRepository.getAllCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مشتریان نسیه'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Customer>>(
          future: _customersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(
                child: Text('هنوز مشتری‌ای ثبت نشده'),
              );
            }

            final customers = snapshot.data!;

            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];

                return FutureBuilder<int>(
                  future: _debtService
                      .calculateCustomerDebt(customer.id!),
                  builder: (context, debtSnapshot) {
                    final debt =
                        debtSnapshot.data ?? 0;

                    return ListTile(
                      title: Text(customer.fullName),
                      subtitle: Text(
                        'بدهی: $debt ریال',
                      ),
                      trailing:
                          const Icon(Icons.chevron_left),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
