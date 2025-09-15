import 'package:flutter/material.dart';
import 'package:tax_collect/screens/success_screen.dart';
import '../database/database_helper.dart';
import '../models/tax_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DataScreen extends StatefulWidget {
  // final String qrCodeId;

  const DataScreen({Key? key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _taxTypeController = TextEditingController();
  final TextEditingController _payerNameController = TextEditingController();
  final TextEditingController _shopDesignationController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
       
title: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    FaIcon(FontAwesomeIcons.chartBar, color: Colors.white),
    SizedBox(width: 8),
    Text(
      "Paiement",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
  ],
),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _codeController,
                label: "Numéro",
                icon: Icons.code_sharp,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _taxTypeController,
                label: "Type de taxe",
                icon: Icons.category,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _payerNameController,
                label: "Nom du payeur",
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _shopDesignationController,
                label: "Désignation boutique",
                icon: Icons.storefront,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _amountController,
                label: "Montant à payer",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveData,
                icon: const Icon(Icons.save, size: 22),
                label: const Text(
                  "Enregistrer",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      final taxData = TaxData(
        qrCodeId: _codeController.text,
        taxType: _taxTypeController.text,
        payerName: _payerNameController.text,
        shopDesignation: _shopDesignationController.text,
        amount: double.parse(_amountController.text),
        paymentDate: DateTime.now(),
      );

      try {
        await DatabaseService().insertTaxData(taxData);
      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) =>const SuccessScreen(),
  ),
);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Erreur: $e')),
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
