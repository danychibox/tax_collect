import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tax_collect/database/database_helper.dart';
import 'package:tax_collect/providers/payment_provider.dart';
import 'package:tax_collect/providers/tax_provider.dart';
import 'package:tax_collect/providers/taxpayer_provider.dart';
import 'package:tax_collect/screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await DatabaseHelper.instance.initDB();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaxpayerProvider()),
        ChangeNotifierProvider(create: (_) => TaxProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaxCollect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}