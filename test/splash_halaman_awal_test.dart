import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemilik/halaman_awal.dart';
import 'package:pemilik/login.dart';
import 'package:pemilik/main.dart';
import 'package:pemilik/splash_screen.dart';

void main() {
  testWidgets('SplashScreen displays SVG waves, logo, and navigates to HalamanAwal',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    // Initial frame
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(Image), findsOneWidget); // logo.png

    // Advance animation steps
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 1000));

    // Wait for the final hold timer and transition
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();

    // Settle on HalamanAwal
    expect(find.byType(HalamanAwal), findsOneWidget);
    expect(find.text('Login / Daftar'), findsOneWidget);
  });

  testWidgets('SplashScreen tap immediately skips to HalamanAwal',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);

    // Tap to skip
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    expect(find.byType(HalamanAwal), findsOneWidget);
  });

  testWidgets('HalamanAwal displays background, logo, and navigates to Login',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HalamanAwal(),
      ),
    );

    expect(find.text('Login / Daftar'), findsOneWidget);
    // Background image and Logo image
    expect(find.byType(Image), findsNWidgets(2));

    await tester.tap(find.text('Login / Daftar'));
    await tester.pumpAndSettle();

    expect(find.byType(Login), findsOneWidget);
  });

  testWidgets('App starts with SplashScreen in MyApp', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(SplashScreen), findsOneWidget);

    // Skip to HalamanAwal
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    expect(find.byType(HalamanAwal), findsOneWidget);
  });
}
