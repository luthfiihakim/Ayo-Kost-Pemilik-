import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart'; // Menghubungkan ke file login.dart yang tadi kita buat

class HalamanAwal extends StatelessWidget {
  const HalamanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Latar belakang lengkungan dari Figma
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/Splash Screen 1.svg', // Pastikan nama file SVG-mu sesuai
              fit: BoxFit.cover,
            ),
          ),
          // Tombol interaktif asli Flutter
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0), // Jarak tombol dari bawah layar
              child: ElevatedButton(
                onPressed: () {
                  // Aksi untuk berpindah halaman
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F9D9D), // Warna hijau tosca
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Bikin ujung tombol melengkung rapi
                  ),
                  elevation: 5, // Tambahan bayangan agar terlihat timbul
                ),
                child: const Text(
                  'Login / Daftar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}