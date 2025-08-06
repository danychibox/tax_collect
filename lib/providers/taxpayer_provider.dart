import 'package:flutter/material.dart';
import 'package:tax_collect/database/database_helper.dart';
import 'package:tax_collect/models/taxpayer.dart';

class TaxpayerProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Taxpayer> _taxpayers = [];

  List<Taxpayer> get taxpayers => _taxpayers;

  Future<void> loadTaxpayers() async {
    final db = await _dbHelper.database;
    final maps = await db.query('taxpayers');
    _taxpayers = maps.map((map) => Taxpayer.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addTaxpayer(Taxpayer taxpayer) async {
    final db = await _dbHelper.database;
    await db.insert('taxpayers', taxpayer.toMap());
    await loadTaxpayers();
  }

  Future<void> updateTaxpayer(Taxpayer taxpayer) async {
    final db = await _dbHelper.database;
    await db.update(
      'taxpayers',
      taxpayer.toMap(),
      where: 'id = ?',
      whereArgs: [taxpayer.id],
    );
    await loadTaxpayers();
  }

  Future<void> deleteTaxpayer(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'taxpayers',
      where: 'id = ?',
      whereArgs: [id],
    );
    await loadTaxpayers();
  }
}