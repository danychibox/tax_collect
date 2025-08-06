import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_collect/models/tax.dart';
import 'package:tax_collect/providers/tax_provider.dart';
import 'package:uuid/uuid.dart';

class TaxFormDialog extends StatefulWidget {
  final Tax? tax;

  const TaxFormDialog({super.key, this.tax});

  @override
  _TaxFormDialogState createState() => _TaxFormDialogState();
}

class _TaxFormDialogState extends State<TaxFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.tax != null) {
      _nameController.text = widget.tax!.name;
      _amountController.text = widget.tax!.amount.toString();
      _descriptionController.text = widget.tax!.description ?? '';
      _dueDate = widget.tax!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.tax == null ? 'Ajouter une taxe' : 'Modifier la taxe'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom de la taxe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Montant (FCFA)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Montant invalide';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_dueDate == null
                    ? 'Sélectionner une date d\'échéance'
                    : 'Échéance: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _dueDate = date);
                  }
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
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
          onPressed: _saveTax,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveTax() async {
    if (_formKey.currentState!.validate()) {
      final taxProvider = Provider.of<TaxProvider>(context, listen: false);
      final now = DateTime.now();

      if (widget.tax == null) {
        // Ajout d'une nouvelle taxe
        final tax = Tax(
          id: const Uuid().v4(),
          name: _nameController.text,
          amount: double.parse(_amountController.text),
          dueDate: _dueDate,
          description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
          createdAt: now,
        );

        await taxProvider.addTax(tax);
      } else {
        // Modification d'une taxe existante
        final tax = Tax(
          id: widget.tax!.id,
          name: _nameController.text,
          amount: double.parse(_amountController.text),
          dueDate: _dueDate,
          description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
          createdAt: widget.tax!.createdAt,
        );

        await taxProvider.updateTax(tax);
      }

      Navigator.pop(context);
    }
  }
}