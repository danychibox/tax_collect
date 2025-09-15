import 'dart:convert';

class TaxData {
  final String payerName;
  final String shopDesignation;
  final String taxType;
  final String amount;
  final DateTime paymentDate;
  final String qrCodeId;

  TaxData({
    required this.payerName,
    required this.shopDesignation,
    required this.taxType,
    required this.amount,
    required this.paymentDate,
    required this.qrCodeId,
  });

  factory TaxData.fromApi(Map<String, dynamic> json) {
    final entete = jsonDecode(json["entete"] ?? "{}");
    final serviceTaxateur = jsonDecode(json["service_taxateur"] ?? "{}");
    final serviceOrdonateur = jsonDecode(json["service_ordonateur"] ?? "{}");
    final serviceComptable = jsonDecode(json["service_comptable"] ?? "{}");

    return TaxData(
      payerName: entete["nom_proprietaire"] ?? "Non défini",
      shopDesignation: entete["nom_raison_sociel"] ?? "Non défini",
      taxType: serviceTaxateur["acte_generateur_libelle"] ?? "Non défini",
      amount: serviceTaxateur["montant_chiffre"] ?? "0",
      paymentDate: DateTime.tryParse(serviceComptable["date_perception"] ?? "") ?? DateTime.now(),
      qrCodeId: json["id"].toString(),
    );
  }
}
