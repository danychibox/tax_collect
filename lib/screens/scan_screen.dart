import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../database/database_helper.dart';
import '../models/tax_data.dart';
import 'data_screen.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = false;

  @override
  void reassemble() {
    super.reassemble();
    // 🔄 Nécessaire pour Android & iOS
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        centerTitle: true,
        actions: [
          // 🔦 Flash
          IconButton(
            icon: FutureBuilder<bool?>(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                final flashOn = snapshot.data ?? false;
                return Icon(
                  flashOn ? Icons.flash_on : Icons.flash_off,
                  color: flashOn ? theme.colorScheme.primary : Colors.grey,
                );
              },
            ),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {}); // refresh l’icône
            },
          ),
          // 🔄 Switch caméra
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () async {
              await controller?.flipCamera();
              setState(() {}); // refresh UI
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 📷 Vue caméra
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: theme.colorScheme.primary,
              borderRadius: 20,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 250,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    controller!.scannedDataStream.listen((scanData) async {
      if (isScanning) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⏳ Scan déjà en cours..."),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      setState(() => isScanning = true);
      final qrCodeId = scanData.code ?? '';

      // Vérifier si déjà existant
      final existingData =
          await DatabaseService().getTaxDataByQrCode(qrCodeId);

      if (existingData != null) {
        _showExistingDataDialog(existingData);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DataScreen(qrCodeId: qrCodeId),
          ),
        );
      }

      Future.delayed(
        const Duration(seconds: 2),
        () => setState(() => isScanning = false),
      );
    });
  }

  void _showExistingDataDialog(TaxData taxData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '📌 Données existantes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
