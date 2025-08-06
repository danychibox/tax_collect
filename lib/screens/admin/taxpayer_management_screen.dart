import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_collect/models/taxpayer.dart';
import 'package:tax_collect/providers/taxpayer_provider.dart';
import 'package:tax_collect/widgets/taxpayer_form_dialog.dart';

class TaxpayerManagementScreen extends StatefulWidget {
  const TaxpayerManagementScreen({super.key});

  @override
  _TaxpayerManagementScreenState createState() => _TaxpayerManagementScreenState();
}

class _TaxpayerManagementScreenState extends State<TaxpayerManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaxpayerProvider>(context, listen: false).loadTaxpayers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taxpayerProvider = Provider.of<TaxpayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Contribuables'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTaxpayerDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: taxpayerProvider.taxpayers.length,
        itemBuilder: (context, index) {
          final taxpayer = taxpayerProvider.taxpayers[index];
          return ListTile(
            title: Text(taxpayer.name),
            subtitle: Text(taxpayer.address ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditTaxpayerDialog(context, taxpayer),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteTaxpayer(context, taxpayer.id),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddTaxpayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const TaxpayerFormDialog(),
    );
  }

  void _showEditTaxpayerDialog(BuildContext context, Taxpayer taxpayer) {
    showDialog(
      context: context,
      builder: (_) => TaxpayerFormDialog(taxpayer: taxpayer),
    );
  }

  void _deleteTaxpayer(BuildContext context, String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce contribuable?'),
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
      await Provider.of<TaxpayerProvider>(context, listen: false).deleteTaxpayer(id);
    }
  }
}