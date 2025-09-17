import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tax_collect/screens/success_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // === ENTETE ===
  String? selectedEts; // ID de l'établissement sélectionné
  final TextEditingController communeCtrl = TextEditingController();
  final TextEditingController serviceCtrl = TextEditingController();
  final TextEditingController numeroCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController nompropriCtrl = TextEditingController();

  // === SERVICE TAXATEUR ===
  final TextEditingController noteDebitCtrl = TextEditingController();
  final TextEditingController nomRaisonCtrl = TextEditingController();
  final TextEditingController acteGenerateurCtrl = TextEditingController();
  final TextEditingController articleBudgetaireCtrl = TextEditingController();
  final TextEditingController montantChiffreCtrl = TextEditingController();
  final TextEditingController montantLettreCtrl = TextEditingController();

  // === SERVICE ORDONNATEUR ===
  final TextEditingController dateReceptionCtrl = TextEditingController();
  final TextEditingController avisMotiveCtrl = TextEditingController();
  final TextEditingController montantViseChiffreCtrl = TextEditingController();
  final TextEditingController montantViseLettreCtrl = TextEditingController();

  // === SERVICE COMPTABLE ===
  final TextEditingController datePriseChargeCtrl = TextEditingController();
  final TextEditingController codeComptableCtrl = TextEditingController();
  final TextEditingController montantPercuChiffreCtrl = TextEditingController();
  final TextEditingController montantPercuLettreCtrl = TextEditingController();
  final TextEditingController modePaiementCtrl = TextEditingController();

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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            FaIcon(FontAwesomeIcons.fileInvoiceDollar, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Formulaire Taxe",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
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
              _saveData();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          steps: [
            // === ÉTAPE 1 : ENTETE ===
            Step(
              title: const Text("Entête"),
              isActive: _currentStep >= 0,
              content: Column(
                children: [
                  DropdownSearch<Map<String, dynamic>>(
                    items: (filter, InfiniteScrollProps) => fetchEtablissements(filter),
                    itemAsString: (Map<String, dynamic> u) => u["Designation"] ?? "Sans nom",
                    dropdownBuilder: (context, selectedItem) {
                      if (selectedItem == null) return const Text("Sélectionnez un établissement");
                      return Text(
                        "${selectedItem["Designation"]} - ${selectedItem["Proprietaire"] ?? ""}",
                        style: const TextStyle(fontSize: 14),
                      );
                    },
                    onChanged: (value) {
                      setState(() {
                        selectedEts = value?["id"].toString();
                      });
                    },
                    decoratorProps: const DropDownDecoratorProps(
                      decoration: InputDecoration(
                        // labelText: "Etablissement",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    validator: (value) => value == null ? "Sélectionnez un établissement" : null,
                  ),
                  _buildTextField(nompropriCtrl, "Propriétaire"),
                  _buildTextField(communeCtrl, "Commune"),
                  _buildTextField(serviceCtrl, "Service"),
                  _buildTextField(numeroCtrl, "Numéro"),
                  _buildDateField(dateCtrl, "Date"), // Champ date
                ],
              ),
            ),

            // === ÉTAPE 2 : SERVICE TAXATEUR ===
            Step(
              title: const Text("Service taxateur"),
              isActive: _currentStep >= 1,
              content: Column(
                children: [
                  _buildTextField(noteDebitCtrl, "Note de débit"),
                  _buildTextField(nomRaisonCtrl, "Nom / Raison sociale"),
                  _buildTextField(acteGenerateurCtrl, "Acte générateur"),
                  _buildTextField(articleBudgetaireCtrl, "Article budgétaire"),
                  _buildTextField(montantChiffreCtrl, "Montant en chiffres",
                      type: TextInputType.number),
                  _buildTextField(montantLettreCtrl, "Montant en lettres"),
                ],
              ),
            ),

            // === ÉTAPE 3 : SERVICE ORDONNATEUR ===
            Step(
              title: const Text("Service ordonnateur"),
              isActive: _currentStep >= 2,
              content: Column(
                children: [
                  _buildDateField(dateReceptionCtrl, "Date de réception"),
                  _buildTextField(avisMotiveCtrl, "Avis motivé"),
                  _buildTextField(montantViseChiffreCtrl, "Montant visé en chiffres",
                      type: TextInputType.number),
                  _buildTextField(montantViseLettreCtrl, "Montant visé en lettres"),
                ],
              ),
            ),

            // === ÉTAPE 4 : SERVICE COMPTABLE ===
            Step(
              title: const Text("Service comptable"),
              isActive: _currentStep >= 3,
              content: Column(
                children: [
                  _buildDateField(datePriseChargeCtrl, "Date prise en charge"),
                  _buildTextField(codeComptableCtrl, "Code désignation comptable"),
                  _buildTextField(montantPercuChiffreCtrl, "Montant perçu en chiffres",
                      type: TextInputType.number),
                  _buildTextField(montantPercuLettreCtrl, "Montant perçu en lettres"),
                  _buildTextField(modePaiementCtrl, "Mode de paiement"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Champ texte classique
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
          prefixIcon: const Icon(Icons.edit, color: Colors.blueAccent),
         border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
          )
        ),
      ),
    );
  }

  // Champ date avec DatePicker
  Widget _buildDateField(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: ctrl,
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
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
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Envoi des données
  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      final entete = jsonEncode({
        "commune": communeCtrl.text,
        "service": serviceCtrl.text,
        "numero": numeroCtrl.text,
        "date": dateCtrl.text,
        "nom_proprietaire":nompropriCtrl.text,
      });

      final serviceTaxateur = jsonEncode({
        "note_debit_numero": noteDebitCtrl.text,
        "nom_raison_sociel": nomRaisonCtrl.text,
        "acte_generateur_libelle": acteGenerateurCtrl.text,
        "article_budgetaire": articleBudgetaireCtrl.text,
        "montant_chiffre": montantChiffreCtrl.text,
        "montant_en_lettre": montantLettreCtrl.text,
      });

      final serviceOrdonateur = jsonEncode({
        "date_reception": dateReceptionCtrl.text,
        "avis_motive": avisMotiveCtrl.text,
        "montant_vise_en_chiffre": montantViseChiffreCtrl.text,
        "montant_vise_en_lettre": montantViseLettreCtrl.text,
      });

      final serviceComptable = jsonEncode({
        "date_prise_en_charge": datePriseChargeCtrl.text,
        "code_designation_comptable": codeComptableCtrl.text,
        "montant_percu_en_chiffre": montantPercuChiffreCtrl.text,
        "montant_percu_en_lettre": montantPercuLettreCtrl.text,
        "mode_de_paiement": modePaiementCtrl.text,
      });

      final Map<String, dynamic> jsonData = {
        "id_etablissement": selectedEts != null ? int.parse(selectedEts!) : null,
        "entete": entete,
        "service_taxateur": serviceTaxateur,
        "service_ordonateur": serviceOrdonateur,
        "service_comptable": serviceComptable,
      };

      try {
        final response = await http.post(
          Uri.parse("http://api-tax.etatcivilnordkivu.cd/etablissement/perception"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(jsonData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SuccessScreen()),
          );
        } else {
          _showSnack("Erreur: ${response.statusCode}");
        }
      } catch (e) {
        _showSnack("Impossible d'envoyer les données");
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
