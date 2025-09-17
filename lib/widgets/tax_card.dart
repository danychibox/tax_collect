// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:tax_collect/screens/update_data.dart';
import '../models/tax_data.dart';
// import '../screens/update_data.dart'; // ✅ importe ta page de modification

class TaxCard extends StatelessWidget {
  final TaxData taxData;

  const TaxCard({Key? key, required this.taxData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // 🎯 Circle Avatar avec initiale
            CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              child: Text(
                taxData.payerName.isNotEmpty
                    ? taxData.payerName[0].toUpperCase()
                    : "?",
                style: TextStyle(
                  fontSize: 24,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Infos principales
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taxData.payerName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Boutique: ${taxData.shopDesignation}',
                      style: theme.textTheme.bodyMedium),
                  Text('Taxe: ${taxData.taxType}',
                      style: theme.textTheme.bodyMedium),
                  Text(
                    'Montant: ${taxData.amount} FC',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Date: ${taxData.paymentDate.toLocal().toString().split(' ')[0]}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            // QR code ID
            Column(
              // spacing: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              children:[ 
                const SizedBox(height: 3),
              Text(
                '${taxData.paymentDate.toLocal().toString().split(' ')[0]}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
               IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              tooltip: "Modifier",
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDataScreen(
                      existingData: taxData.toJson(), // 👈 conversion en Map
                    ),
                  ),
                );

                if (result == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enregistrement modifié avec succès")),
                  );
                }
              },
            ),
              ]
            ),   // ✏️ Bouton édition
           
          ],
        ),
      ),
    );
  }
}
