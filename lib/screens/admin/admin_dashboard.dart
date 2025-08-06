import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tax_collect/providers/tax_provider.dart';
// import 'package:tax_collect/providers/payment_provider.dart';
import 'package:tax_collect/screens/admin/tax_management_screen.dart';
import 'package:tax_collect/screens/admin/taxpayer_management_screen.dart';
import 'package:tax_collect/screens/admin/reports_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord Admin'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildDashboardCard(
            context,
            Icons.people,
            'Gestion des Contribuables',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TaxpayerManagementScreen(),
                ),
              );
            },
          ),
          _buildDashboardCard(
            context,
            Icons.receipt,
            'Gestion des Taxes',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TaxManagementScreen(),
                ),
              );
            },
          ),
          _buildDashboardCard(
            context,
            Icons.bar_chart,
            'Rapports',
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReportsScreen(),
                ),
              );
            },
          ),
          _buildDashboardCard(
            context,
            Icons.payment,
            'Paiements',
            () {
              // Naviguer vers l'écran des paiements
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}