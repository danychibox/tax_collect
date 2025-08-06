import 'package:flutter/material.dart';
import 'package:tax_collect/models/payment.dart';
import 'package:tax_collect/widgets/receipt_widget.dart';

class PaymentHistoryScreen extends StatelessWidget {
  final Payment payment;

  const PaymentHistoryScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du paiement'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ReceiptWidget(payment: payment),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Générer et partager le PDF
        },
        child: const Icon(Icons.share),
      ),
    );
  }
}