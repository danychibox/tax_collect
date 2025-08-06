import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tax_collect/models/payment.dart';
import 'package:intl/intl.dart';

class PdfGenerator {
  static Future<pw.Document> generateReceipt(Payment payment) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'REÇU DE PAIEMENT',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Mairie de [Votre Ville]',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(thickness: 2),
              _buildPdfRow('Numéro de reçu', payment.receiptNumber),
              _buildPdfRow('Date', DateFormat('dd/MM/yyyy').format(payment.date)),
              _buildPdfRow('Heure', DateFormat('HH:mm').format(payment.date)),
              pw.Divider(thickness: 2),
              _buildPdfRow('Méthode de paiement', payment.method ?? 'Non spécifié'),
              _buildPdfRow('Montant', '${payment.amount} FCFA'),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 30),
              pw.Text(
                'Merci pour votre paiement',
                style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  static pw.Row _buildPdfRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(value),
      ],
    );
  }
}