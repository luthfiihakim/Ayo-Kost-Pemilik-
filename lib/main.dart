import 'package:flutter/material.dart';
import 'halaman_awal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ayo Kost!',
      theme: ThemeData(
        fontFamily: 'Poppins', // font default seluruh aplikasi
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F9D9D)),
        useMaterial3: true,
      ),
      home: const HalamanAwal(),
    );
  }
}