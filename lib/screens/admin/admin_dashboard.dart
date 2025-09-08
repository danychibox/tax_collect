import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_collect/providers/tax_provider.dart';
import 'package:tax_collect/providers/payment_provider.dart';
import 'package:tax_collect/providers/taxpayer_provider.dart';
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final taxpayerCount = context.watch<TaxpayerProvider>().taxpayers.length;
    final taxCount = context.watch<TaxProvider>().taxes.length;
    final payments = context.watch<PaymentProvider>().paymentDetails;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Tableau de Bord Admin"),
      ),
      body: Column(
        children: [
          // --- HEADER ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF141633),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.person,
                  label: "assujettis",
                  value: taxpayerCount.toString(),
                ),
                _StatItem(
                  icon: Icons.list,
                  label: "taxes",
                  value: taxCount.toString(),
                ),
                _StatItem(
                  icon: Icons.payment,
                  label: "paiements",
                  value: payments.length.toString(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- LISTE DES PAIEMENTS ---
          Expanded(
            child: payments.isEmpty
                ? const Center(
                    child: Text("Aucun paiement enregistré"),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return _PaymentCard(
                        name: payment.taxpayerName,
                        tax: payment.taxName,
                        amount: "${payment.amount} fc",
                        date:
                            "${payment.date}", // format simple
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// --- Widget pour les stats du haut ---
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

// --- Widget pour chaque carte paiement ---
class _PaymentCard extends StatelessWidget {
  final String name;
  final String tax;
  final String amount;
  final String date;

  const _PaymentCard({
    required this.name,
    required this.tax,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("nom"),
                Text("taxe"),
                Text("montant"),
                Text("date"),
              ],
            ),
            const Divider(color: Colors.white54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.person, color: Colors.black54),
                    Text(name),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.list, color: Colors.black54),
                    Text(tax),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.sentiment_satisfied, color: Colors.black54),
                    Text(amount),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Colors.black54, size: 20),
                    Text(date),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
