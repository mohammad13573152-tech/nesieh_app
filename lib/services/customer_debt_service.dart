import '../repositories/purchase_repository.dart';
import '../repositories/payment_repository.dart';

class CustomerDebtService {
  final PurchaseRepository _purchaseRepository =
      PurchaseRepository();
  final PaymentRepository _paymentRepository =
      PaymentRepository();

  /// بدهی کل یک مشتری (ریال)
  Future<int> calculateCustomerDebt(int customerId) async {
    final purchases =
        await _purchaseRepository.getPurchasesByCustomer(
            customerId);

    int totalPurchaseAmount = 0;

    for (final p in purchases) {
      totalPurchaseAmount +=
          await _purchaseRepository
              .calculateTotalAmount(p.id!);
    }

    final totalPaid =
        await _paymentRepository
            .calculateTotalPaidByCustomer(customerId);

    return totalPurchaseAmount - totalPaid;
  }
}

