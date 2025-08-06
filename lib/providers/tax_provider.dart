import 'package:flutter/material.dart';
import 'package:tax_collect/database/database_helper.dart';
import 'package:tax_collect/models/tax.dart';

class TaxProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Tax> _taxes = [];

  List<Tax> get taxes => _taxes;

  Future<void> loadTaxes() async {
    final db = await _dbHelper.database;
    final maps = await db.query('taxes');
    _taxes = maps.map((map) => Tax.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addTax(Tax tax) async {
    final db = await _dbHelper.database;
    await db.insert('taxes', tax.toMap());
    await loadTaxes();
  }

  Future<void> updateTax(Tax tax) async {
    final db = await _dbHelper.database;
    await db.update(
      'taxes',
      tax.toMap(),
      where: 'id = ?',
      whereArgs: [tax.id],
    );
    await loadTaxes();
  }

  Future<void> deleteTax(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'taxes',
      where: 'id = ?',
      whereArgs: [id],
    );
    await loadTaxes();
  }
}