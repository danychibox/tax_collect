import 'package:flutter/material.dart';
import 'package:tax_collect/screens/home_screen.dart';

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

          bool isLargeScreen = width > 600;

          double padding = isLargeScreen ? width * 0.1 : 40;
          double inputHeight = isLargeScreen ? 60 : 50;
          double buttonWidth = isLargeScreen ? width * 0.25 : width * 0.6;

          return Center(
            child: SingleChildScrollView(
              child: isLargeScreen
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ====== Colonne gauche : formulaire ======
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: height * 0.1),

                                // Champ utilisateur
                                SizedBox(
                                  height: inputHeight,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey.shade400,
                                      hintText: "utilisateur",
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Champ mot de passe
                                SizedBox(
                                  height: inputHeight,
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey.shade400,
                                      hintText: "mot de passe",
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide.none,
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
                                      backgroundColor:
                                          const Color(0xFF0D1B52),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomeScreen()),
                                      );
                                    },
                                    child: const Text(
                                      "CONNEXION",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),
                                const Text(
                                  "mot de passe oublié",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ====== Ligne de séparation ======
                        Container(
                          width: 1,
                          height: height * 0.6,
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                        ),

                        // ====== Colonne droite : logo + titre ======
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/logo.png", // mets ton image ici
                                height: 120,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "TAXE COLLECTE",
                                style: TextStyle(
                                  color: Color(0xFF0D1B52),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "VILLE DE BENI",
                                style: TextStyle(
                                  color: Color(0xFF0D1B52),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo + titre en haut pour mobile
                        Image.asset(
                          "assets/logo.png",
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "TAXE COLLECTE",
                          style: TextStyle(
                            color: Color(0xFF0D1B52),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "VILLE DE BENI",
                          style: TextStyle(
                            color: Color(0xFF0D1B52),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Formulaire
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Column(
                            children: [
                              SizedBox(
                                height: inputHeight,
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey.shade400,
                                    hintText: "utilisateur",
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: inputHeight,
                                child: TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey.shade400,
                                    hintText: "mot de passe",
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: buttonWidth,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D1B52),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeScreen()),
                                    );
                                  },
                                  child: const Text(
                                    "CONNEXION",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "mot de passe oublié",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
