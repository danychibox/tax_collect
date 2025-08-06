import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_collect/models/taxpayer.dart';
import 'package:tax_collect/providers/taxpayer_provider.dart';
import 'package:uuid/uuid.dart';

class TaxpayerFormDialog extends StatefulWidget {
  final Taxpayer? taxpayer;

  const TaxpayerFormDialog({super.key, this.taxpayer});

  @override
  _TaxpayerFormDialogState createState() => _TaxpayerFormDialogState();
}

class _TaxpayerFormDialogState extends State<TaxpayerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.taxpayer != null) {
      _nameController.text = widget.taxpayer!.name;
      _addressController.text = widget.taxpayer!.address ?? '';
      _phoneController.text = widget.taxpayer!.phone ?? '';
      _emailController.text = widget.taxpayer!.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.taxpayer == null ? 'Ajouter un contribuable' : 'Modifier le contribuable'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom complet'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Adresse'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saveTaxpayer,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveTaxpayer() async {
    if (_formKey.currentState!.validate()) {
      final taxpayerProvider = Provider.of<TaxpayerProvider>(context, listen: false);
      final now = DateTime.now();

      if (widget.taxpayer == null) {
        // Ajout d'un nouveau contribuable
        final taxpayer = Taxpayer(
          id: const Uuid().v4(),
          name: _nameController.text,
          address: _addressController.text.isEmpty ? null : _addressController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          createdAt: now,
        );

        await taxpayerProvider.addTaxpayer(taxpayer);
      } else {
        // Modification d'un contribuable existant
        final taxpayer = Taxpayer(
          id: widget.taxpayer!.id,
          name: _nameController.text,
          address: _addressController.text.isEmpty ? null : _addressController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          createdAt: widget.taxpayer!.createdAt,
        );

        await taxpayerProvider.updateTaxpayer(taxpayer);
      }

      Navigator.pop(context);
    }
  }
}