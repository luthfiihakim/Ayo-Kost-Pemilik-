import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Wajib diimport untuk membaca file .svg


class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ayo Kost!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan SizedBox.expand agar gambar SVG memenuhi seluruh layar secara proporsional
      body: SizedBox.expand(
        child: SvgPicture.asset(
          'assets/Splash Screen 6.svg', // Memanggil file splash screen final
          fit: BoxFit.cover, // Menyesuaikan ukuran layar tanpa error overflow
        ),
      ),
    );
  }
}