import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';

class EditDataScreen extends StatefulWidget {
  final Map<String, dynamic> existingData; // Données à modifier

  const EditDataScreen({Key? key, required this.existingData}) : super(key: key);

  @override
  _EditDataScreenState createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // === Controllers ===
  String? selectedEts;
  final TextEditingController communeCtrl = TextEditingController();
  final TextEditingController serviceCtrl = TextEditingController();
  final TextEditingController numeroCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController nompropriCtrl = TextEditingController();

  final TextEditingController noteDebitCtrl = TextEditingController();
  final TextEditingController nomRaisonCtrl = TextEditingController();
  final TextEditingController acteGenerateurCtrl = TextEditingController();
  final TextEditingController articleBudgetaireCtrl = TextEditingController();
  final TextEditingController montantChiffreCtrl = TextEditingController();
  final TextEditingController montantLettreCtrl = TextEditingController();

  final TextEditingController dateReceptionCtrl = TextEditingController();
  final TextEditingController avisMotiveCtrl = TextEditingController();
  final TextEditingController montantViseChiffreCtrl = TextEditingController();
  final TextEditingController montantViseLettreCtrl = TextEditingController();

  final TextEditingController datePriseChargeCtrl = TextEditingController();
  final TextEditingController codeComptableCtrl = TextEditingController();
  final TextEditingController montantPercuChiffreCtrl = TextEditingController();
  final TextEditingController montantPercuLettreCtrl = TextEditingController();
  final TextEditingController modePaiementCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final data = widget.existingData;

    selectedEts = data["id_etablissement"]?.toString();
    communeCtrl.text = data["commune"] ?? "";
    serviceCtrl.text = data["service"] ?? "";
    numeroCtrl.text = data["numero"] ?? "";
    dateCtrl.text = data["date"] ?? "";
    nompropriCtrl.text = data["nom_proprietaire"] ?? "";

    noteDebitCtrl.text = data["note_debit_numero"] ?? "";
    nomRaisonCtrl.text = data["nom_raison_sociel"] ?? "";
    acteGenerateurCtrl.text = data["acte_generateur_libelle"] ?? "";
    articleBudgetaireCtrl.text = data["article_budgetaire"] ?? "";
    montantChiffreCtrl.text = data["montant_chiffre"] ?? "";
    montantLettreCtrl.text = data["montant_en_lettre"] ?? "";

    dateReceptionCtrl.text = data["date_reception"] ?? "";
    avisMotiveCtrl.text = data["avis_motive"] ?? "";
    montantViseChiffreCtrl.text = data["montant_vise_en_chiffre"] ?? "";
    montantViseLettreCtrl.text = data["montant_vise_en_lettre"] ?? "";

    datePriseChargeCtrl.text = data["date_prise_en_charge"] ?? "";
    codeComptableCtrl.text = data["code_designation_comptable"] ?? "";
    montantPercuChiffreCtrl.text = data["montant_percu_en_chiffre"] ?? "";
    montantPercuLettreCtrl.text = data["montant_percu_en_lettre"] ?? "";
    modePaiementCtrl.text = data["mode_de_paiement"] ?? "";
  }

  // Charger les établissements depuis l’API
  Future<List<Map<String, dynamic>>> fetchEtablissements(String filter) async {
    try {
      final response = await http.get(
        Uri.parse("http://api-tax.etatcivilnordkivu.cd/etablissement"),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List data = decoded["data"];
        return data.map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erreur API établissement: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            FaIcon(FontAwesomeIcons.edit, color: Colors.white),
            SizedBox(width: 8),
            Text("Modifier Taxe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 3) {
              setState(() => _currentStep++);
            } else {
              _updateData();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          steps: [
            Step(title: const Text("Entête"), isActive: _currentStep >= 0, content: _buildStep1()),
            Step(title: const Text("Service taxateur"), isActive: _currentStep >= 1, content: _buildStep2()),
            Step(title: const Text("Service ordonnateur"), isActive: _currentStep >= 2, content: _buildStep3()),
            Step(title: const Text("Service comptable"), isActive: _currentStep >= 3, content: _buildStep4()),
          ],
        ),
      ),
    );
  }

  // Étapes Stepper
  Widget _buildStep1() => Column(
        children: [
          DropdownSearch<Map<String, dynamic>>(
            items: (filter, InfiniteScrollProps) => fetchEtablissements(filter),
            itemAsString: (Map<String, dynamic> u) => u["Designation"] ?? "Sans nom",
            selectedItem: {"id": selectedEts, "Designation": "Établissement existant"},
            onChanged: (value) {
              setState(() {
                selectedEts = value?["id"].toString();
              });
            },
            decoratorProps: const DropDownDecoratorProps(
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            validator: (value) => value == null ? "Sélectionnez un établissement" : null,
          ),
          _buildTextField(nompropriCtrl, "Propriétaire"),
          _buildTextField(communeCtrl, "Commune"),
          _buildTextField(serviceCtrl, "Service"),
          _buildTextField(numeroCtrl, "Numéro"),
          _buildDateField(dateCtrl, "Date"),
        ],
      );

  Widget _buildStep2() => Column(
        children: [
          _buildTextField(noteDebitCtrl, "Note de débit"),
          _buildTextField(nomRaisonCtrl, "Nom / Raison sociale"),
          _buildTextField(acteGenerateurCtrl, "Acte générateur"),
          _buildTextField(articleBudgetaireCtrl, "Article budgétaire"),
          _buildTextField(montantChiffreCtrl, "Montant en chiffres", type: TextInputType.number),
          _buildTextField(montantLettreCtrl, "Montant en lettres"),
        ],
      );

  Widget _buildStep3() => Column(
        children: [
          _buildDateField(dateReceptionCtrl, "Date de réception"),
          _buildTextField(avisMotiveCtrl, "Avis motivé"),
          _buildTextField(montantViseChiffreCtrl, "Montant visé en chiffres", type: TextInputType.number),
          _buildTextField(montantViseLettreCtrl, "Montant visé en lettres"),
        ],
      );

  Widget _buildStep4() => Column(
        children: [
          _buildDateField(datePriseChargeCtrl, "Date prise en charge"),
          _buildTextField(codeComptableCtrl, "Code désignation comptable"),
          _buildTextField(montantPercuChiffreCtrl, "Montant perçu en chiffres", type: TextInputType.number),
          _buildTextField(montantPercuLettreCtrl, "Montant perçu en lettres"),
          _buildTextField(modePaiementCtrl, "Mode de paiement"),
        ],
      );

  // Champs
  Widget _buildTextField(TextEditingController ctrl, String label,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade300,
          prefixIcon: const Icon(Icons.edit, color: Colors.orange),
           border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
          )
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: ctrl,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.tryParse(ctrl.text) ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            ctrl.text = "${pickedDate.toLocal()}".split(' ')[0];
          }
        },
        validator: (value) => value!.isEmpty ? "Champ obligatoire" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.orange),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Mise à jour des données
  void _updateData() async {
    if (_formKey.currentState!.validate()) {
    // 🔹 Bloc entête
final entete = jsonEncode({
  "commune": communeCtrl.text,
  "service": serviceCtrl.text,
  "numero": numeroCtrl.text,
  "date": dateCtrl.text,
  "nom_proprietaire": nompropriCtrl.text,
});

// 🔹 Bloc service taxateur
final serviceTaxateur = jsonEncode({
  "note_debit_numero": noteDebitCtrl.text,
  "nom_raison_sociel": nomRaisonCtrl.text,
  "acte_generateur_libelle": acteGenerateurCtrl.text,
  "article_budgetaire": articleBudgetaireCtrl.text,
  "montant_chiffre": montantChiffreCtrl.text,
  "montant_en_lettre": montantLettreCtrl.text,
});

// 🔹 Bloc service ordonateur
final serviceOrdonateur = jsonEncode({
  "date_reception": dateReceptionCtrl.text,
  "avis_motive": avisMotiveCtrl.text,
  "montant_vise_en_chiffre": montantViseChiffreCtrl.text,
  "montant_vise_en_lettre": montantViseLettreCtrl.text,
});

// 🔹 Bloc service comptable
final serviceComptable = jsonEncode({
  "date_prise_en_charge": datePriseChargeCtrl.text,
  "code_designation_comptable": codeComptableCtrl.text,
  "montant_percu_en_chiffre": montantPercuChiffreCtrl.text,
  "montant_percu_en_lettre": montantPercuLettreCtrl.text,
  "mode_de_paiement": modePaiementCtrl.text,
});

// 🔹 JSON final à envoyer
final Map<String, dynamic> jsonData = {
  "id": widget.existingData["id"], // tu avais un id dans ton code initial
  "id_etablissement": selectedEts != null ? int.parse(selectedEts!) : null,
  "entete": entete,
  "service_taxateur": serviceTaxateur,
  "service_ordonateur": serviceOrdonateur,
  "service_comptable": serviceComptable,
};


      try {
        final response = await http.put(
          Uri.parse("http://api-tax.etatcivilnordkivu.cd/etablissement/perception/${widget.existingData["id"]}"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(jsonData),
        );

        if (response.statusCode == 200) {
          Navigator.pop(context, true); // Retourne avec succès
        } else {
          _showSnack("Erreur: ${response.statusCode}");
        }
      } catch (e) {
        _showSnack("Impossible de modifier les données");
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
