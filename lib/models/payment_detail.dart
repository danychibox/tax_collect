class PaymentDetail {
  final String id;
  final String taxpayerName;
  final String taxName;
  final double amount;
  final String? method;
  final String? date;

  PaymentDetail({
    required this.id,
    required this.taxpayerName,
    required this.taxName,
    required this.amount,
    this.method,
    this.date,
  });

  factory PaymentDetail.fromMap(Map<String, dynamic> map) {
    return PaymentDetail(
      id: map['id'],
      taxpayerName: map['taxpayerName'],
      taxName: map['taxName'],
      amount: map['amount'],
      method: map['method'],
      date: map['date'],
    );
  }
}
