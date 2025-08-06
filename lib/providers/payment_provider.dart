import 'package:flutter/material.dart';
import 'package:tax_collect/database/database_helper.dart';
import 'package:tax_collect/models/payment.dart';

class PaymentProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Payment> _payments = [];

  List<Payment> get payments => _payments;

  Future<void> loadPayments() async {
    final db = await _dbHelper.database;
    final maps = await db.query('payments');
    _payments = maps.map((map) => Payment.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addPayment(Payment payment) async {
    final db = await _dbHelper.database;
    await db.insert('payments', payment.toMap());
    await loadPayments();
  }

  Future<void> deletePayment(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'payments',
      where: 'id = ?',
      whereArgs: [id],
    );
    await loadPayments();
  }
}