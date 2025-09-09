import 'package:flutter/material.dart';
import 'scan_screen.dart';
import 'data_screen.dart';
import '../database/database_helper.dart';
import '../models/tax_data.dart';
import '../widgets/tax_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaxData> taxDataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DatabaseService().getAllTaxData();
    setState(() => taxDataList = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion Taxes'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: taxDataList.isEmpty
          ? Center(child: Text('Aucune donnée enregistrée'))
          : ListView.builder(
              itemCount: taxDataList.length,
              itemBuilder: (context, index) => TaxCard(taxData: taxDataList[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScanScreen()),
        ),
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}