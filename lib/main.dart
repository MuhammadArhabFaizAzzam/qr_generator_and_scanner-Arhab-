import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart'; // untuk kReleaseMode
import 'package:flutter/material.dart';

import 'ui/splash_screen.dart';
import 'ui/home_screen.dart';
import 'ui/qr_generator_screen.dart';
import 'ui/qr_scanner_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // mati otomatis saat build release
      defaultDevice: Devices.ios.iPhone11ProMax,
      devices: [
        Devices.ios.iPhone11ProMax, // aktif
        // Devices.android.samsungGalaxyS23Ultra,
        // Devices.ios.iPadPro11Inches,
      ],
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Integrasi Device Preview
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      debugShowCheckedModeBanner: false,
      title: 'QRODE - QR Generator & Scanner',

      // Tema global menggunakan Material 3 dengan gaya Premium Corporate
      theme: ThemeData(
        fontFamily: 'Manrope',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E236C), // Deep Indigo
          primary: const Color(0xFF2E236C),
          secondary: const Color(0xFF17153B), // Midnight Blue
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFBFBFE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF17153B),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF17153B),
          ),
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E236C),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF2E236C), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),

      // Routing sederhana dengan named routes
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/create': (context) => const QrGeneratorScreen(),
        '/scan': (context) => const QrScannerScreen(),
      },
    );
  }
}
