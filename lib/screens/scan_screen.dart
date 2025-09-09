import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../database/database_helper.dart';
import '../models/tax_data.dart';
import 'data_screen.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner QR Code'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return Icon(Icons.flash_off);
                  case TorchState.on:
                    return Icon(Icons.flash_on);
                }
              },
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) async {
          if (isScanning) return;
          
          setState(() => isScanning = true);
          final List<Barcode> barcodes = capture.barcodes;
          
          if (barcodes.isNotEmpty) {
            final String qrCodeId = barcodes.first.rawValue ?? '';
            
            // Vérifier si le QR code existe déjà
            final existingData = await DatabaseService().getTaxDataByQrCode(qrCodeId);
            
            if (existingData != null) {
              // Afficher les données existantes
              _showExistingDataDialog(existingData);
            } else {
              // Naviguer vers l'écran de saisie des données
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DataScreen(qrCodeId: qrCodeId),
                ),
              );
            }
          }
          
          Future.delayed(Duration(seconds: 2), () => setState(() => isScanning = false));
        },
      ),
    );
  }

  void _showExistingDataDialog(TaxData taxData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Données existantes'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ID: ${taxData.qrCodeId}'),
            Text('Nom: ${taxData.payerName}'),
            Text('Boutique: ${taxData.shopDesignation}'),
            Text('Montant: ${taxData.amount} FCFA'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}