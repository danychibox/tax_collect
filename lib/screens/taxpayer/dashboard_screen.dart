import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_collect/providers/tax_provider.dart';
import 'package:tax_collect/providers/payment_provider.dart';
import 'package:tax_collect/screens/taxpayer/taxes_screen.dart';
import 'package:tax_collect/screens/taxpayer/payment_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaxProvider>(context, listen: false).loadTaxes();
      Provider.of<PaymentProvider>(context, listen: false).loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taxProvider = Provider.of<TaxProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mes Taxes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: taxProvider.taxes.length,
                itemBuilder: (context, index) {
                  final tax = taxProvider.taxes[index];
                  return Card(
                    child: ListTile(
                      title: Text(tax.name),
                      subtitle: Text('${tax.amount} FCFA'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaxesScreen(tax: tax),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Historique des Paiements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: paymentProvider.payments.length,
                itemBuilder: (context, index) {
                  final payment = paymentProvider.payments[index];
                  return Card(
                    child: ListTile(
                      title: Text('Paiement #${payment.receiptNumber}'),
                      subtitle: Text('${payment.amount} FCFA'),
                      trailing: const Icon(Icons.receipt),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentHistoryScreen(payment: payment),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}