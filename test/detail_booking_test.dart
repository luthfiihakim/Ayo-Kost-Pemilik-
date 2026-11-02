import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemilik/detail_booking_page.dart';
import 'package:pemilik/informasi_riwayat_booking.dart';
import 'package:pemilik/app_style.dart';

void main() {
  testWidgets('DetailBookingPage renders all sections, fields, badge, and navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DetailBookingPage(),
      ),
    );

    // Verify Header
    expect(find.text('Informasi Booking'), findsNWidgets(2)); // Header title and Card 1 title
    expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);

    // Verify Card 1: Informasi Booking
    expect(find.text('No. Booking'), findsOneWidget);
    expect(find.text('BK20251010'), findsOneWidget);
    expect(find.text('Tanggal Booking'), findsOneWidget);
    expect(find.text('20 Okt 2026'), findsNWidgets(2)); // Tanggal Booking and Tanggal Mulai Sewa
    expect(find.text('Durasi Sewa'), findsOneWidget);
    expect(find.text('6 bulan'), findsOneWidget);
    expect(find.text('Status Pembayaran'), findsOneWidget);
    expect(find.text('Lunas'), findsOneWidget);
    expect(find.text('Tanggal Mulai Sewa'), findsOneWidget);
    expect(find.text('Tanggal Berakhir Sewa'), findsOneWidget);
    expect(find.text('20 Apr 2027'), findsOneWidget);

    // Verify Card 2: Informasi Kost
    expect(find.text('Informasi Kost'), findsOneWidget);
    expect(find.text('Nama Kost'), findsOneWidget);
    expect(find.text('Kost Meranti'), findsOneWidget);
    expect(find.text('Alamat'), findsOneWidget);
    expect(find.text('Reulet'), findsOneWidget);

    // Verify Card 3: Informasi Penyewa
    expect(find.text('Informasi Penyewa'), findsOneWidget);
    expect(find.text('Nama'), findsOneWidget);
    expect(find.text('Rina'), findsOneWidget);
    expect(find.text('No. HP'), findsOneWidget);
    expect(find.text('0812 3456 7890'), findsOneWidget);

    // Verify Bottom Navigation Bar
    expect(find.byType(AppBottomNav), findsOneWidget);
    expect(find.text('Booking'), findsOneWidget);
    expect(find.text('Ulasan'), findsOneWidget);
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets('InformasiRiwayatBookingPage renders bottom navigation with Booking active',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: InformasiRiwayatBookingPage(),
      ),
    );

    expect(find.byType(AppBottomNav), findsOneWidget);
    expect(find.text('Booking'), findsNWidgets(2)); // 1 in header, 1 in bottom nav
    expect(find.text('Beranda'), findsOneWidget);
  });
}
