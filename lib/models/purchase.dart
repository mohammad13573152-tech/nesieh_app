class Purchase {
  final int? id;
  final int customerId;
  final int date; // timestamp
  final int totalAmount; // rial
  final int paidAmount; // rial
  final String? note;

  Purchase({
    this.id,
    required this.customerId,
    required this.date,
    required this.totalAmount,
    required this.paidAmount,
    this.note,
  });

  int get remainingAmount => totalAmount - paidAmount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'date': date,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'note': note,
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'] as int?,
      customerId: map['customer_id'],
      date: map['date'],
      totalAmount: map['total_amount'],
      paidAmount: map['paid_amount'],
      note: map['note'],
    );
  }
}
