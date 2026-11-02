import 'package:flutter/material.dart';
import 'app_style.dart';
import 'login.dart';

class HalamanAwal extends StatelessWidget {
  const HalamanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Rectangle 20: Gambar latar belakang penuh dari Figma (Halaman Awal.png)
          Positioned.fill(
            child: Image.asset(
              'assets/Halaman Awal.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: kTeal,
                  child: const Center(
                    child: Icon(Icons.apartment, size: 80, color: Colors.white),
                  ),
                );
              },
            ),
          ),

          // 2. LOGO_4-removebg-preview 1: Logo AYO KOST! mengapung langsung di area langit
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Image.asset(
                  'assets/logo.png',
                  width: 175,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),

          // 3. Rectangle 21: Gradient overlay teal di bagian bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 220,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFF0F9D9D).withValues(alpha: 0.65),
                    const Color(0xFF0F9D9D).withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 4. Rectangle 18 & Teks "Login / Daftar": Tombol pill rounded dengan gradasi teal-frosted
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: Container(
                  width: 215,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0F9D9D),
                        Color(0xFF86BFC3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x35000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Login()),
                        );
                      },
                      child: Center(
                        child: Text(
                          'Login / Daftar',
                          style: poppins(
                            size: 15,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
