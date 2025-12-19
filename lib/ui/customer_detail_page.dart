
import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_debt_service.dart';
import '../repositories/purchase_repository.dart'; // 👈 اضافه شده برای لیست خریدها
import '../models/purchase.dart'; // 👈 اضافه شده برای لیست خریدها
import 'add_purchase_page.dart'; // 👈 مطمئن شو که این import هست

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
  late Future<List<Purchase>> _purchasesFuture; // 👈 Future برای لیست خریدها
  late CustomerDebtService _customerDebtService;
  late PurchaseRepository _purchaseRepository; // 👈 ریپازیتوری برای خریدها

  @override
  void initState() {
    super.initState();
    _customerDebtService = CustomerDebtService();
    _purchaseRepository = PurchaseRepository(); // 👈 مقداردهی ریپازیتوری
    _totalDebtFuture = _customerDebtService.calculateCustomerTotalDebt(widget.customer.id!);
    _purchasesFuture = _purchaseRepository.getPurchasesByCustomerId(widget.customer.id!); // 👈 مقداردهی Future خریدها
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.name),
        actions: [
          // اینجا می‌توانید دکمه‌های دیگری اضافه کنید، مثلاً ویرایش مشتری
        ],
      ),
      body: SingleChildScrollView( // 👈 body را از Center به SingleChildScrollView تغییر دادیم
        child: Column( // 👈 و محتوا را داخل Column قرار دادیم
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTotalDebtSection(), // 👈 بخش نمایش بدهی کل
            const Divider(), // جداکننده برای زیبایی
            _buildPurchaseList(), // 👈 بخش نمایش لیست خریدها
            // می‌توانید در اینجا دکمه‌ها یا بخش‌های دیگری اضافه کنید
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async { // 👈 اینجا async اضافه شد
          final result = await Navigator.push( // 👈 اینجا await و ذخیره result اضافه شد
            context,
            MaterialPageRoute(
              builder: (_) => AddPurchasePage(
                customer: widget.customer,
              ),
            ),
          );

          // 👈 منطق رفرش بر اساس result برگشتی از AddPurchasePage
          if (result == true) {
            setState(() {
              _totalDebtFuture = _customerDebtService.calculateCustomerTotalDebt(widget.customer.id!);
              _purchasesFuture = _purchaseRepository.getPurchasesByCustomerId(widget.customer.id!);
            });
          }
        },
      ),
    );
  }

  Widget _buildTotalDebtSection() {
    return FutureBuilder<int>(
      future: _totalDebtFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'خطا در بارگذاری بدهی: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          final totalDebt = snapshot.data ?? 0;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'بدهی کل مشتری',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalDebt تومان', // 👈 اینجا نمایش داده می‌شود
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildPurchaseList() {
    return FutureBuilder<List<Purchase>>(
      future: _purchasesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'خطا در بارگذاری خریدها: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'تا کنون خریدی ثبت نشده است.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        } else {
          // 👈 اینجا لیست خریدها را نمایش می‌دهیم
          // از ListView.builder استفاده می‌کنیم چون ممکن است لیست بلند باشد
          return ListView.builder(
            shrinkWrap: true, // مهم: برای اینکه ListView داخل SingleChildScrollView کار کند
            physics: const NeverScrollableScrollPhysics(), // مهم: برای جلوگیری از اسکرول دوگانه
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final purchase = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(purchase.description), // 👈 فرض می‌کنیم Purchase دارای description است
                  subtitle: Text('مقدار: ${purchase.amount} تومان'), // 👈 فرض می‌کنیم Purchase دارای amount است
                  trailing: Text(purchase.date.toLocal().toString().split(' ')[0]), // 👈 فرض می‌کنیم Purchase دارای date است
                  // می‌توانید onPressed برای دیدن جزئیات خرید اضافه کنید
                ),
              );
            },
          );
        }
      },
    );
  }
}

