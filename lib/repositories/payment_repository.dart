import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/payment.dart';

class PaymentRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// ثبت پرداخت
  Future<int> insertPayment(Payment payment) async {
    final db = await _dbHelper.database;
    return await db.insert('payments', payment.toMap());
  }

  /// پرداخت‌های یک خرید
  Future<List<Payment>> getPaymentsByPurchase(
      int purchaseId) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'payments',
      where: 'purchase_id = ?',
      whereArgs: [purchaseId],
      orderBy: 'date DESC',
    );

    return maps.map((e) => Payment.fromMap(e)).toList();
  }

  /// پرداخت‌های یک مشتری (تمام خریدها)
  Future<List<Payment>> getPaymentsByCustomer(
      int customerId) async {
    final db = await _dbHelper.database;

    final result = await db.rawQuery('''
      SELECT p.*
      FROM payments p
      INNER JOIN purchases pu
        ON p.purchase_id = pu.id
      WHERE pu.customer_id = ?
      ORDER BY p.date DESC
    ''', [customerId]);

    return result.map((e) => Payment.fromMap(e)).toList();
  }

  /// 💰 محاسبه مجموع پرداخت‌های مشتری
  Future<int> calculateTotalPaidByCustomer(
      int customerId) async {
    final payments =
        await getPaymentsByCustomer(customerId);

    return payments.fold<int>(
      0,
      (sum, p) => sum + p.amount,
    );
  }
}

