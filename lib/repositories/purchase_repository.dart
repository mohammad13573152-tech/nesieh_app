import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/purchase.dart';
import '../models/purchase_item.dart';
import '../models/payment.dart';

class PurchaseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// ثبت خرید جدید + آیتم‌ها
  Future<int> createPurchase(
    Purchase purchase,
    List<PurchaseItem> items,
  ) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      final purchaseId =
          await txn.insert('purchases', purchase.toMap());

      for (final item in items) {
        await txn.insert(
          'purchase_items',
          item.copyWith(purchaseId: purchaseId).toMap(),
        );
      }

      return purchaseId;
    });
  }

  /// دریافت خریدهای یک مشتری
  Future<List<Purchase>> getPurchasesByCustomer(
      int customerId) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'purchases',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'date DESC',
    );

    return maps.map((e) => Purchase.fromMap(e)).toList();
  }

  /// آیتم‌های یک خرید
  Future<List<PurchaseItem>> getItemsOfPurchase(
      int purchaseId) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'purchase_items',
      where: 'purchase_id = ?',
      whereArgs: [purchaseId],
    );

    return maps
        .map((e) => PurchaseItem.fromMap(e))
        .toList();
  }

  /// پرداخت‌های یک خرید
  Future<List<Payment>> getPaymentsOfPurchase(
      int purchaseId) async {
    final db = await _dbHelper.database;

    final maps = await db.query(
      'payments',
      where: 'purchase_id = ?',
      whereArgs: [purchaseId],
    );

    return maps.map((e) => Payment.fromMap(e)).toList();
  }

  /// محاسبه مبلغ کل خرید
  Future<int> calculateTotalAmount(int purchaseId) async {
    final items = await getItemsOfPurchase(purchaseId);

    return items.fold<int>(
      0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  /// محاسبه مبلغ پرداخت‌شده
  Future<int> calculatePaidAmount(int purchaseId) async {
    final payments = await getPaymentsOfPurchase(purchaseId);

    return payments.fold<int>(
      0,
      (sum, payment) => sum + payment.amount,
    );
  }

  /// ❤️ بدهی واقعی خرید
  Future<int> calculateRemainingAmount(
      int purchaseId) async {
    final total = await calculateTotalAmount(purchaseId);
    final paid = await calculatePaidAmount(purchaseId);
    return total - paid;
  }
}
