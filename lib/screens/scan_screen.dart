// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import '../database/database_helper.dart';
// import '../models/tax_data.dart';
// import 'data_screen.dart';

// class ScanScreen extends StatefulWidget {
//   @override
//   _ScanScreenState createState() => _ScanScreenState();
// }

// class _ScanScreenState extends State<ScanScreen> {
//   final MobileScannerController controller = MobileScannerController();
//   bool isScanning = false;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scanner QR Code'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: ValueListenableBuilder(
//               valueListenable: controller.torchState,
//               builder: (context, state, child) {
//                 final flashOn = state == TorchState.on;
//                 return Icon(
//                   flashOn ? Icons.flash_on : Icons.flash_off,
//                   color: flashOn ? theme.colorScheme.primary : Colors.grey,
//                 );
//               },
//             ),
//             onPressed: () => controller.toggleTorch(),
//           ),
//           IconButton(
//             icon: const Icon(Icons.cameraswitch),
//             onPressed: () => controller.switchCamera(),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(
//             controller: controller,
//             allowDuplicates: false,
//             onDetect: (capture) async {
//               final List<Barcode> barcodes = capture.barcodes;
//               if (barcodes.isEmpty) return;

//               final qrCodeId = barcodes.first.rawValue ?? '';

//               if (isScanning) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("⏳ Scan déjà en cours..."),
//                     behavior: SnackBarBehavior.floating,
//                   ),
//                 );
//                 return;
//               }

//               setState(() => isScanning = true);

//               final existingData =
//                   await DatabaseService().getTaxDataByQrCode(qrCodeId);

//               if (existingData != null) {
//                 _showExistingDataDialog(existingData);
//               } else {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DataScreen(qrCodeId: qrCodeId),
//                   ),
//                 );
//               }

//               Future.delayed(
//                 const Duration(seconds: 2),
//                 () => setState(() => isScanning = false),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _showExistingDataDialog(TaxData taxData) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           '📌 Données existantes',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('ID: ${taxData.qrCodeId}'),
//             Text('Nom: ${taxData.payerName}'),
//             Text('Boutique: ${taxData.shopDesignation}'),
//             Text('Montant: ${taxData.amount} FCFA'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Fermer'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }
