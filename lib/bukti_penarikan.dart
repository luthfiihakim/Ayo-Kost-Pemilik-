import 'package:flutter/material.dart';
import 'app_style.dart';
import 'saldo_model.dart';
import 'saldo_widgets.dart';

/// Layar "Bukti Penarikan" setelah penarikan berhasil.
class BuktiPenarikanPage extends StatelessWidget {
  final Penarikan penarikan;
  const BuktiPenarikanPage({super.key, required this.penarikan});

  @override
  Widget build(BuildContext context) {
    final p = penarikan;
    final r = p.rekening;

    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: HeaderBerwarna(
                      title: 'Bukti Penarikan',
                      tinggi: 132,
                      color: Color(0xFF0E9090),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, yFigma(context, 74), 15, 24),
                    child: Column(
                      children: [
                        // Kartu status berhasil
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: kCardShadow,
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Color(0xD90F9D9D),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  width: 68,
                                  height: 68,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF4F7FC),
                                    shape: BoxShape.circle,
                                    boxShadow: kCardShadow,
                                  ),
                                  child: const Icon(Icons.check,
                                      color: kTeal, size: 42),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Penarikan Berhasil',
                                  style: poppins(
                                      size: 16, weight: FontWeight.w600)),
                              Text(tglLengkap(p.waktu),
                                  style: poppins(
                                      size: 12,
                                      weight: FontWeight.w500,
                                      color: kGreyNav)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Rincian
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: kCardShadow,
                          ),
                          child: Column(
                            children: [
                              BarisInfo(label: 'No Referensi', nilai: p.noRef),
                              const GarisPemisah(),
                              BarisInfo(
                                  label: 'Tanggal & Waktu',
                                  nilai: tglWaktuPendek(p.waktu)),
                              const GarisPemisah(),
                              const BarisInfo(
                                  label: 'Jenis Transaksi',
                                  nilai: 'Penarikan Saldo'),
                              const GarisPemisah(),
                              BarisInfo(
                                label: 'Rekening Tujuan',
                                nilai:
                                    '${r.nomor}\n(${r.bank.singkat} - a/n ${r.nama})',
                                nilaiWeight: FontWeight.w600,
                                nilaiSize: 13,
                              ),
                              const GarisPemisah(),
                              BarisInfo(
                                label: 'Jumlah',
                                nilai: rpTitik(p.jumlah),
                                nilaiWeight: FontWeight.w700,
                              ),
                              const GarisPemisah(),
                              BarisInfo(
                                label: 'Biaya Admin',
                                nilai: rpTitik(p.biayaAdmin),
                                nilaiWeight: FontWeight.w400,
                              ),
                              const GarisPemisah(),
                              BarisInfo(
                                label: 'Total',
                                nilai: rupiah(p.diterima),
                                nilaiWeight: FontWeight.w700,
                              ),
                              const GarisPemisah(),
                              const BarisInfo(
                                label: 'Metode',
                                nilai: 'Transfer',
                                nilaiWeight: FontWeight.w400,
                              ),
                              const GarisPemisah(),
                              const BarisInfo(
                                label: 'Status',
                                nilaiWidget: PillStatus(
                                  label: 'Berhasil',
                                  background: Color(0xFF95D2D2),
                                  foreground: Color(0xFF14532D),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text('Transaksi Selesai',
                            style: poppins(
                                size: 15,
                                weight: FontWeight.w700,
                                color: kTealDark)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                17, 8, 17, MediaQuery.of(context).padding.bottom + 16),
            child: TombolUtama(
              label: 'Kembali ke Beranda',
              height: 44,
              radius: 10,
              fontSize: 16,
              weight: FontWeight.w600,
              onPressed: () => kembaliKeBeranda(context),
            ),
          ),
        ],
      ),
    );
  }
}