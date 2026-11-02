import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'halaman_awal.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Urutan frame transisi lengkungan ombak sesuai Figma
  final List<String> _frames = const [
    'assets/images/Splash Screen.svg',
    'assets/images/Splash Screen 1.svg',
    'assets/images/Splash Screen 2.svg',
    'assets/images/Splash Screen 3.svg',
    'assets/images/Splash Screen 4.svg',
    'assets/images/Splash Screen 5.svg',
  ];

  int _currentFrame = 0;
  bool _tampilkanLogo = false;
  Timer? _animTimer;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    // Animasi pergantian lengkungan frame-by-frame
    _animTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted) return;
      if (_currentFrame < _frames.length - 1) {
        setState(() {
          _currentFrame++;
          if (_currentFrame >= 4) {
            _tampilkanLogo = true;
          }
        });
      } else {
        timer.cancel();
        setState(() {
          _tampilkanLogo = true;
        });
        // Jeda sejenak saat logo & ombak sudah lengkap sebelum ke Halaman Awal
        _navTimer =
            Timer(const Duration(milliseconds: 1600), _lanjutKeHalamanAwal);
      }
    });
  }

  void _lanjutKeHalamanAwal() {
    if (!mounted) return;
    _animTimer?.cancel();
    _navTimer?.cancel();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HalamanAwal(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _animTimer?.cancel();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _lanjutKeHalamanAwal, // Ketuk layar untuk melewati splash
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // 1. Lengkungan Ombak Teal dari SVG Figma
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: SvgPicture.asset(
                  _frames[_currentFrame],
                  key: ValueKey<int>(_currentFrame),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 2. Logo AYO KOST! di tengah layar dengan animasi fade & scale
            Center(
              child: AnimatedOpacity(
                opacity: _tampilkanLogo ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: AnimatedScale(
                  scale: _tampilkanLogo ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
