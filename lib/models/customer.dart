class Customer {
  final int? id;
  final String fullName;
  final String? phone;
  final String? note;

  Customer({
    this.id,
    required this.fullName,
    this.phone,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'note': note,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as int?,
      fullName: map['full_name'],
      phone: map['phone'],
      note: map['note'],
    );
  }
}
