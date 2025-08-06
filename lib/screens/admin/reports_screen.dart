import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_collect/models/payment.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tax_collect/providers/payment_provider.dart';
import 'package:tax_collect/providers/tax_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final taxProvider = Provider.of<TaxProvider>(context);

    // Préparer les données pour le graphique
    final monthlyData = _prepareMonthlyData(paymentProvider.payments);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports et Statistiques'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Paiements par Mois',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<MonthlyData, String>(
                    dataSource: monthlyData,
                    xValueMapper: (MonthlyData data, _) => data.month,
                    yValueMapper: (MonthlyData data, _) => data.amount,
                    name: 'Paiements',
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Récapitulatif des Taxes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DataTable(
              columns: const [
                DataColumn(label: Text('Taxe')),
                DataColumn(label: Text('Montant')),
                DataColumn(label: Text('Paiements')),
              ],
              rows: taxProvider.taxes.map((tax) {
                final payments = paymentProvider.payments
                    .where((payment) => payment.taxId == tax.id)
                    .length;
                
                return DataRow(cells: [
                  DataCell(Text(tax.name)),
                  DataCell(Text('${tax.amount} FCFA')),
                  DataCell(Text('$payments')),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<MonthlyData> _prepareMonthlyData(List<Payment> payments) {
    final now = DateTime.now();
    final monthlyData = <MonthlyData>[];
    
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      final monthName = '${date.month}/${date.year}';
      
      final total = payments
          .where((p) => p.date.month == date.month && p.date.year == date.year)
          .fold(0.0, (sum, p) => sum + p.amount);
      
      monthlyData.add(MonthlyData(monthName, total));
    }
    
    return monthlyData;
  }
}

class MonthlyData {
  final String month;
  final double amount;

  MonthlyData(this.month, this.amount);
}