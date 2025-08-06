import 'package:flutter/material.dart';
import 'package:tax_collect/models/tax.dart';
import 'package:tax_collect/screens/taxpayer/payment_screen.dart';

class TaxesScreen extends StatelessWidget {
  final Tax tax;

  const TaxesScreen({super.key, required this.tax});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tax.name),
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails de la Taxe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Montant', '${tax.amount} FC'),
            _buildDetailRow('Description', tax.description ?? 'Aucune description'),
            if (tax.dueDate != null)
              _buildDetailRow(
                'Date d\'échéance',
                '${tax.dueDate!.day}/${tax.dueDate!.month}/${tax.dueDate!.year}',
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(tax: tax),
                    ),
                  );
                },
                child: const Text('Payer cette taxe'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}