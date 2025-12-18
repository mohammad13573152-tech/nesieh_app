class Payment {
  final int? id;
  final int customerId;
  final int date; // timestamp
  final int amount; // rial
  final String? method;
  final String? note;

  Payment({
    this.id,
    required this.customerId,
    required this.date,
    required this.amount,
    this.method,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'date': date,
      'amount': amount,
      'method': method,
      'note': note,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] as int?,
      customerId: map['customer_id'],
      date: map['date'],
      amount: map['amount'],
      method: map['method'],
      note: map['note'],
    );
  }
}
