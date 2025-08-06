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
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Mes Taxes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 10),
            ...taxProvider.taxes.map((tax) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.account_balance_wallet, color: Colors.blueAccent),
                    title: Text(
                      tax.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${tax.amount} FCFA'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TaxesScreen(tax: tax)),
                      );
                    },
                  ),
                )),

            const SizedBox(height: 30),

            const Text(
              '🧾 Historique des Paiements',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 10),
            ...paymentProvider.payments.map((payment) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long, color: Colors.green),
                    title: Text(
                      'Paiement #${payment.receiptNumber}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${payment.amount} FC'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentHistoryScreen(payment: payment),
                        ),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
