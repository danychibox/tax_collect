class Payment {
  final String id;
  final String taxpayerId;
  final String taxId;
  final double amount;
  final String? method;
  final DateTime date;
  final String receiptNumber;

  Payment({
    required this.id,
    required this.taxpayerId,
    required this.taxId,
    required this.amount,
    this.method,
    required this.date,
    required this.receiptNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taxpayerId': taxpayerId,
      'taxId': taxId,
      'amount': amount,
      'method': method,
      'date': date.toIso8601String(),
      'receiptNumber': receiptNumber,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      taxpayerId: map['taxpayerId'],
      taxId: map['taxId'],
      amount: map['amount'],
      method: map['method'],
      date: DateTime.parse(map['date']),
      receiptNumber: map['receiptNumber'],
    );
  }
}