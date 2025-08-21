import 'package:flutter/material.dart';
import 'package:tax_collect/screens/admin/admin_dashboard.dart';
import 'package:tax_collect/screens/taxpayer/dashboard_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          // Déterminer si l'écran est large (tablette / PC)
          bool isLargeScreen = width > 600;

          // Ajustement des tailles en fonction de l'écran
          double padding = isLargeScreen ? width * 0.2 : 40;
          double titleSize = isLargeScreen ? 32 : 24;
          double subtitleSize = isLargeScreen ? 18 : 14;
          double inputHeight = isLargeScreen ? 60 : 50;
          double buttonWidth = isLargeScreen ? width * 0.4 : width * 0.6;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Bandeau haut
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: height * 0.05),
                  decoration: const BoxDecoration(
                    color: Color(0xFF151931),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "TAXE COLLECTE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "VILLE DE BENI",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.1),

                // Champ utilisateur
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: SizedBox(
                    height: inputHeight,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade400,
                        hintText: "utilisateur",
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Champ mot de passe
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: SizedBox(
                    height: inputHeight,
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade400,
                        hintText: "mot de passe",
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Bouton connexion
                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1B52),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "CONNEXION",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.05),
              ],
            ),
          );
        },
      ),
    );
  }
}
