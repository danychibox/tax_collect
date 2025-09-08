import 'package:flutter/material.dart';
import 'package:tax_collect/database/database_helper.dart';
import 'package:tax_collect/models/payment.dart';
import 'package:tax_collect/models/payment_detail.dart';

class PaymentProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<PaymentDetail> _paymentDetails = [];

  List<PaymentDetail> get paymentDetails => _paymentDetails;

  /// Charger tous les paiements avec noms contribuables + taxes
  Future<void> loadPayments() async {
    final db = await _dbHelper.database;

    final maps = await db.rawQuery('''
      SELECT p.id, p.amount, p.method, p.date,
             t.name AS taxpayerName,
             tx.name AS taxName
      FROM payments p
      INNER JOIN taxpayers t ON p.taxpayerId = t.id
      INNER JOIN taxes tx ON p.taxId = tx.id
    ''');

    _paymentDetails = maps.map((map) => PaymentDetail.fromMap(map)).toList();
    notifyListeners();
  }

  /// Ajouter un paiement
  Future<void> addPayment(Payment payment) async {
    final db = await _dbHelper.database;
    await db.insert('payments', payment.toMap());
    await loadPayments(); // recharge avec join
  }

  /// Supprimer un paiement
  Future<void> deletePayment(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'payments',
      where: 'id = ?',
      whereArgs: [id],
    );
    await loadPayments(); // recharge avec join
  }
}
