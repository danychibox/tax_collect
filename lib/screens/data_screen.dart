import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/tax_data.dart';

class DataScreen extends StatefulWidget {
  final String qrCodeId;

  DataScreen({required this.qrCodeId});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taxTypeController = TextEditingController();
  final TextEditingController _payerNameController = TextEditingController();
  final TextEditingController _shopDesignationController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enregistrement Taxe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _taxTypeController,
                decoration: InputDecoration(labelText: 'Type de taxe'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _payerNameController,
                decoration: InputDecoration(labelText: 'Nom du payeur'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _shopDesignationController,
                decoration: InputDecoration(labelText: 'Désignation boutique'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Montant à payer'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveData,
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      final taxData = TaxData(
        qrCodeId: widget.qrCodeId,
        taxType: _taxTypeController.text,
        payerName: _payerNameController.text,
        shopDesignation: _shopDesignationController.text,
        amount: double.parse(_amountController.text),
        paymentDate: DateTime.now(),
      );

      try {
        await DatabaseService().insertTaxData(taxData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Données enregistrées avec succès!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _taxTypeController.dispose();
    _payerNameController.dispose();
    _shopDesignationController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}