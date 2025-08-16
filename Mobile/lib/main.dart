import 'package:flutter/material.dart';
import 'splash/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/io_client.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting for French
  await initializeDateFormatting('fr_FR', null);

  // Create an HTTP client with insecure certificate handling
  HttpClient client = HttpClient();

  // Allow insecure certificates (use this cautiously)
  client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  // Create IOClient with the configured HttpClient
  var ioClient = IOClient(client);

  // Run the app and pass the client to it
  runApp(MyApp(ioClient));
}

class MyApp extends StatelessWidget {
  final IOClient ioClient;

  const MyApp(this.ioClient, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phonocare',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Start with Splash Screen
    );
  }
}
