class PurchaseItem {
  final int? id;
  final int purchaseId;
  final String title;
  final int quantity;
  final int unitPrice; // rial

  PurchaseItem({
    this.id,
    required this.purchaseId,
    required this.title,
    required this.quantity,
    required this.unitPrice,
  });

  int get totalPrice => quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchase_id': purchaseId,
      'title': title,
      'quantity': quantity,
      'unit_price': unitPrice,
    };
  }

  factory PurchaseItem.fromMap(Map<String, dynamic> map) {
    return PurchaseItem(
      id: map['id'] as int?,
      purchaseId: map['purchase_id'],
      title: map['title'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
    );
  }
}
