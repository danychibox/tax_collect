import 'package:flutter/material.dart';
import 'package:tax_collect/models/payment.dart';
import 'package:tax_collect/widgets/receipt_widget.dart';

class PaymentHistoryScreen extends StatelessWidget {
  final Payment payment;

  const PaymentHistoryScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Détails du Paiement'),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ReceiptWidget(payment: payment),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Générer et partager le reçu en PDF
        },
        icon: const Icon(Icons.share),
        label: const Text('Partager'),
        backgroundColor: const Color(0xFF0D47A1),
      ),
    );
  }
}
