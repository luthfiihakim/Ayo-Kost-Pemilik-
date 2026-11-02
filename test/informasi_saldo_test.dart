import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemilik/informasi_saldo_page.dart';

void main() {
  testWidgets('InformasiSaldoPage renders correctly and navigates to TarikSaldoPage',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: InformasiSaldoPage(),
      ),
    );

    // Verify Title & Balance
    expect(find.text('Informasi Saldo'), findsOneWidget);
    expect(find.text('Total Saldo'), findsOneWidget);
    expect(find.text('Rp 9.500.000'), findsOneWidget);
    expect(find.text('Tarik Saldo'), findsOneWidget);

    // Verify Transaction history
    expect(find.text('Riwayat Transaksi'), findsOneWidget);
    expect(find.text('Penarikan Saldo'), findsAtLeastNWidgets(1));
    expect(find.text('Pendapatan Sewa Kost'), findsAtLeastNWidgets(1));

    // Tap Tarik Saldo
    await tester.tap(find.text('Tarik Saldo'));
    await tester.pumpAndSettle();

    expect(find.byType(TarikSaldoPage), findsOneWidget);
  });

  testWidgets(
      'TarikSaldoPage updates calculations, chips, and navigates to BuktiPenarikanPage',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TarikSaldoPage(saldoTersedia: 9500000),
      ),
    );

    expect(find.text('Tarik Saldo'), findsOneWidget);
    expect(find.text('Saldo tersedia'), findsOneWidget);
    expect(find.text('BRI - 738605391203 (M. Hakim)'), findsOneWidget);

    // Default 5.000.000 -> Diterima 4.997.500
    expect(find.text('Rp 4.997.500'), findsOneWidget);

    // Tap Chip Rp 1 Jt
    await tester.tap(find.text('Rp 1 Jt'));
    await tester.pump();

    // Diterima should update to Rp 997.500 (1.000.000 - 2.500)
    expect(find.text('Rp 997.500'), findsOneWidget);

    // Tap Tarik Sekarang
    await tester.tap(find.text('Tarik Sekarang'));
    await tester.pumpAndSettle();

    expect(find.byType(BuktiPenarikanPage), findsOneWidget);
    expect(find.text('Penarikan Berhasil'), findsOneWidget);
    expect(find.text('Rp 1.000.000'), findsOneWidget);
    expect(find.text('Rp 2.500'), findsOneWidget);
    expect(find.text('Rp 997.500'), findsOneWidget);
    expect(find.text('Kembali ke Beranda', skipOffstage: false), findsOneWidget);
  });

  testWidgets('InformasiSaldoPage opens detail on history tap', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: InformasiSaldoPage(),
      ),
    );

    // Tap withdrawal history item -> navigates to BuktiPenarikanPage
    await tester.tap(find.text('24 Okt 2026, 14:10 WIB'));
    await tester.pumpAndSettle();

    expect(find.byType(BuktiPenarikanPage), findsOneWidget);

    // Pop back
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();

    expect(find.byType(InformasiSaldoPage), findsOneWidget);

    // Tap income history item -> opens bottom sheet
    await tester.tap(find.text('20 Okt 2026, 09:30 WIB'));
    await tester.pumpAndSettle();

    expect(find.text('Detail Transaksi Masuk'), findsOneWidget);
    expect(find.text('+ Rp 500.000'), findsNWidgets(2));
  });
}
