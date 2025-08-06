import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tax_collect/models/tax.dart';
import 'package:tax_collect/models/payment.dart'; // ✅ Manquant
import 'package:tax_collect/providers/payment_provider.dart';
import 'package:tax_collect/screens/taxpayer/payment_confirmation_screen.dart';
import 'package:uuid/uuid.dart';

class PaymentScreen extends StatefulWidget {
  final Tax tax;

  const PaymentScreen({super.key, required this.tax});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _paymentMethod = 'Espèces';
  final List<String> _paymentMethods = [
    'Espèces',
    'Mobile Money',
    'Carte Bancaire',
    'Virement',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paiement - ${widget.tax.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Montant à payer: ${widget.tax.amount} FCFA',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                items: _paymentMethods.map((method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Méthode de paiement',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Informations supplémentaires',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Numéro de transaction (si applicable)',
                  border: OutlineInputBorder(),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  child: const Text('Confirmer le paiement'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    if (_formKey.currentState!.validate()) {
      final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
      final paymentId = const Uuid().v4();
      final now = DateTime.now();
      final receiptNumber = 'RC-${now.year}${now.month}${now.day}-${paymentId.substring(0, 4).toUpperCase()}';

      await paymentProvider.addPayment(
        Payment(
          id: paymentId,
          taxpayerId: 'current-user-id', // À remplacer par l'ID réel
          taxId: widget.tax.id,
          amount: widget.tax.amount,
          method: _paymentMethod,
          date: now,
          receiptNumber: receiptNumber,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentConfirmationScreen(
            tax: widget.tax,
            receiptNumber: receiptNumber,
            paymentDate: now,
          ),
        ),
      );
    }
  }
}