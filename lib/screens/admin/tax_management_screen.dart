import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_collect/models/tax.dart';
import 'package:tax_collect/providers/tax_provider.dart';
import 'package:tax_collect/widgets/tax_form_dialog.dart';

class TaxManagementScreen extends StatefulWidget {
  const TaxManagementScreen({super.key});

  @override
  _TaxManagementScreenState createState() => _TaxManagementScreenState();
}

class _TaxManagementScreenState extends State<TaxManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaxProvider>(context, listen: false).loadTaxes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taxProvider = Provider.of<TaxProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Taxes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTaxDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: taxProvider.taxes.length,
        itemBuilder: (context, index) {
          final tax = taxProvider.taxes[index];
          return ListTile(
            title: Text(tax.name),
            subtitle: Text('${tax.amount} FCFA'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditTaxDialog(context, tax),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTax(context, tax.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddTaxDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const TaxFormDialog(),
    );
  }

  void _showEditTaxDialog(BuildContext context, Tax tax) {
    showDialog(
      context: context,
      builder: (_) => TaxFormDialog(tax: tax),
    );
  }

  void _deleteTax(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cette taxe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await Provider.of<TaxProvider>(context, listen: false).deleteTax(id);
    }
  }
}