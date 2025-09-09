import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QRService {
  static Future<String> scanQR() async {
    try {
      final String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Annuler',
        true,
        ScanMode.QR,
      );
      
      if (barcode == '-1') {
        throw Exception('Scan annulé');
      }
      
      return barcode;
    } catch (e) {
      throw Exception('Erreur lors du scan: $e');
    }
  }
}