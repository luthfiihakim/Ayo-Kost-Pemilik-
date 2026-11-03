import 'package:flutter/material.dart';
import 'app_style.dart';
import 'saldo_model.dart';
import 'saldo_widgets.dart';

/// Layar "Penarikan Gagal". "Coba Lagi" kembali ke form Tarik Saldo
/// dengan jumlah yang sudah diisi.
class TransaksiGagalPage extends StatelessWidget {
  final Penarikan penarikan;
  const TransaksiGagalPage({super.key, required this.penarikan});

  static const _penyebab = [
    'Saldo tidak mencukupi',
    'Koneksi internet terputus',
    'Gangguan sementara pada bank atau penyedia pembayaran',
  ];

  void _hubungiCs(BuildContext context) {
    // TODO: arahkan ke WhatsApp / halaman chat CS
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur hubungi CS belum tersedia')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = penarikan;

    return Scaffold(
      backgroundColor: kBackground,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: HeaderBerwarna(
                tinggi: 128,
                color: kMerah,
                tombolKembali: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, yFigma(context, 72), 15, 28),
              child: Column(
                children: [
                  // Kartu status gagal
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: kCardShadow,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Color(0x99FEC7C7),
                            shape: BoxShape.circle,
                            boxShadow: kCardShadow,
                          ),
                          child:
                              const Icon(Icons.close, color: kMerah, size: 40),
                        ),
                        const SizedBox(height: 10),
                        Text('Penarikan Gagal',
                            style: poppins(
                                size: 16,
                                weight: FontWeight.w700,
                                color: kMerah)),
                        Text(tglLengkap(p.waktu),
                            style: poppins(
                                size: 12,
                                weight: FontWeight.w500,
                                color: kGreyNav)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Rincian
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: kCardShadow,
                    ),
                    child: Column(
                      children: [
                        BarisInfo(
                          label: 'No Referensi',
                          nilai: p.noRef,
                          labelColor: kGreyText,
                          labelWeight: FontWeight.w600,
                          nilaiWeight: FontWeight.w600,
                        ),
                        const GarisPemisah(),
                        BarisInfo(
                          label: 'Waktu Pembayaran',
                          nilai: tglWaktuPendek(p.waktu),
                          labelColor: kGreyText,
                          labelWeight: FontWeight.w600,
                          nilaiWeight: FontWeight.w600,
                        ),
                        const GarisPemisah(),
                        const BarisInfo(
                          label: 'Metode pembayaran',
                          nilai: 'Transfer bank',
                          labelColor: kGreyText,
                          labelWeight: FontWeight.w600,
                          nilaiWeight: FontWeight.w600,
                        ),
                        const GarisPemisah(),
                        BarisInfo(
                          label: 'Total bayar',
                          nilai: rupiah(p.diterima),
                          labelColor: kGreyText,
                          labelWeight: FontWeight.w600,
                          nilaiWeight: FontWeight.w700,
                          nilaiSize: 12,
                        ),
                        const GarisPemisah(),
                        const BarisInfo(
                          label: 'Status',
                          labelColor: kGreyText,
                          labelWeight: FontWeight.w600,
                          nilaiWidget: PillStatus(
                            label: 'Gagal',
                            background: Color(0xFFFF0000),
                            foreground: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),
                  // Penyebab
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFF0000), width: 2),
                      boxShadow: kCardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Penyebab yang sering terjadi.',
                            style: poppins(
                                size: 14,
                                weight: FontWeight.w600,
                                color: kTextDark)),
                        const SizedBox(height: 8),
                        for (final teks in _penyebab)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('•  ',
                                    style: poppins(
                                        size: 12,
                                        weight: FontWeight.w500,
                                        color: kTextDark)),
                                Expanded(
                                  child: Text(teks,
                                      style: poppins(
                                          size: 12,
                                          weight: FontWeight.w500,
                                          color: kTextDark)),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          'Coba lagi nanti atau hubungi CS apabila masalah masih berlanjut.',
                          style: poppins(
                              size: 12,
                              weight: FontWeight.w600,
                              color: kTextDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TombolUtama(
                          label: 'Coba Lagi',
                          height: 49,
                          radius: 20,
                          fontSize: 15,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: TombolUtama(
                          label: 'Hubungi CS',
                          height: 49,
                          radius: 20,
                          fontSize: 15,
                          outlined: true,
                          onPressed: () => _hubungiCs(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TombolUtama(
                    label: 'Kembali ke beranda',
                    height: 47,
                    radius: 20,
                    fontSize: 15,
                    outlined: true,
                    onPressed: () => kembaliKeBeranda(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}