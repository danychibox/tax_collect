import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tax_collect/models/tax.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final Tax tax;
  final String receiptNumber;
  final DateTime paymentDate;

  const PaymentConfirmationScreen({
    super.key,
    required this.tax,
    required this.receiptNumber,
    required this.paymentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement confirmé'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Paiement réussi!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildConfirmationDetail('Numéro de reçu', receiptNumber),
            _buildConfirmationDetail('Taxe payée', tax.name),
            _buildConfirmationDetail('Montant', '${tax.amount} FCFA'),
            _buildConfirmationDetail(
              'Date',
              DateFormat('dd/MM/yyyy à HH:mm').format(paymentDate),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Retour à l\'accueil'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}