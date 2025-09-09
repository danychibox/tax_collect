class TaxData {
  final int? id;
  final String qrCodeId;
  final String taxType;
  final String payerName;
  final String shopDesignation;
  final double amount;
  final DateTime paymentDate;

  TaxData({
    this.id,
    required this.qrCodeId,
    required this.taxType,
    required this.payerName,
    required this.shopDesignation,
    required this.amount,
    required this.paymentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'qrCodeId': qrCodeId,
      'taxType': taxType,
      'payerName': payerName,
      'shopDesignation': shopDesignation,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),
    };
  }

  factory TaxData.fromMap(Map<String, dynamic> map) {
    return TaxData(
      id: map['id'],
      qrCodeId: map['qrCodeId'],
      taxType: map['taxType'],
      payerName: map['payerName'],
      shopDesignation: map['shopDesignation'],
      amount: map['amount'],
      paymentDate: DateTime.parse(map['paymentDate']),
    );
  }
}