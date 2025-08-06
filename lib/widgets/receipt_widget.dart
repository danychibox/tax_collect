import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tax_collect/models/payment.dart';

class ReceiptWidget extends StatelessWidget {
  final Payment payment;

  const ReceiptWidget({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'REÇU DE PAIEMENT',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Mairie de [Votre Ville]',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(thickness: 2),
            _buildReceiptRow('Numéro de reçu', payment.receiptNumber),
            _buildReceiptRow('Date', DateFormat('dd/MM/yyyy').format(payment.date)),
            _buildReceiptRow('Heure', DateFormat('HH:mm').format(payment.date)),
            const Divider(thickness: 2),
            _buildReceiptRow('Méthode de paiement', payment.method ?? 'Non spécifié'),
            _buildReceiptRow('Montant', '${payment.amount} FCFA'),
            const Divider(thickness: 2),
            const SizedBox(height: 20),
            const Text(
              'Merci pour votre paiement',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}