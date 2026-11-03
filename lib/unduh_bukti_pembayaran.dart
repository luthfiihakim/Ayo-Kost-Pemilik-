import 'package:flutter/material.dart';
import 'data_penyewa.dart';
import 'halaman_dashboard.dart';

const _teal = Color(0xFF0F9D9D);
const _background = Color(0xFFF4F7FC);
const _abu = Color(0xFF797979);
const _garis = Color(0xFFC5C5C5);

TextStyle _gaya({
  required double size,
  FontWeight weight = FontWeight.w500,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontFamily: 'Poppins',
    fontSize: size,
    fontWeight: weight,
    color: color,
  );
}

/// Struk bukti pembayaran. Dibuka dari tombol "Unduh" dan "Export ke PDF"
/// di halaman detail penyewa.
class UnduhBuktiTransaksi extends StatelessWidget {
  final Penyewa penyewa;

  // Data di bawah ini belum ada di model Penyewa, jadi sementara pakai
  // nilai dari Figma. Ganti dengan data asli kalau sudah tersedia.
  final String waktuBayar;
  final String lokasi;
  final String tipeSewa;
  final String biayaLayanan;

  const UnduhBuktiTransaksi({
    super.key,
    required this.penyewa,
    this.waktuBayar = '13 Oktober 2025, 07:25 WIB',
    this.lokasi = 'Lhokseumawe',
    this.tipeSewa = 'Bulanan',
    this.biayaLayanan = 'Gratis',
  });

  void _kembaliKeBeranda(BuildContext context) {
    // Hapus semua halaman di atasnya lalu tampilkan Beranda
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Dashboard()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _background,
      body: Column(
        children: [
          // Header teal sampai ke status bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(8, top + 12, 20, 20),
            decoration: const BoxDecoration(
              color: _teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Struk Bukti Pembayaran',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _gaya(
                      size: 20,
                      weight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                children: [
                  // Ikon centang
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _teal, width: 5),
                    ),
                    child: const Center(
                      child: Icon(Icons.check, color: _teal, size: 46),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pembayaran Berhasil',
                    style: _gaya(size: 16, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    waktuBayar,
                    style: _gaya(size: 12, color: _abu),
                  ),
                  const SizedBox(height: 20),

                  // Kartu detail transaksi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _baris('ID Transaksi', penyewa.noBooking),
                        const SizedBox(height: 12),
                        _baris('Metode Pembayaran', penyewa.metodeBayar),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status', style: _gaya(size: 12, color: _abu)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Lunas',
                                style: _gaya(
                                  size: 10,
                                  weight: FontWeight.w600,
                                  color: const Color(0xFF14532D),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: _garis, height: 28),
                        _baris('Nama Kos', penyewa.kost),
                        const SizedBox(height: 12),
                        _baris('Penyewa', penyewa.nama),
                        const SizedBox(height: 12),
                        _baris('Lokasi', lokasi),
                        const SizedBox(height: 12),
                        _baris('Tipe Sewa', tipeSewa),
                        const SizedBox(height: 12),
                        _baris('Biaya Layanan', biayaLayanan),
                        const Divider(color: _garis, height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Bayar',
                              style: _gaya(size: 14, weight: FontWeight.w600),
                            ),
                            Text(
                              penyewa.total,
                              style: _gaya(size: 14, weight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Tombol tetap di bawah layar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => _kembaliKeBeranda(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Kembali ke Beranda',
                style: _gaya(
                  size: 16,
                  weight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _baris(String label, String nilai) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _gaya(size: 12, color: _abu)),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            nilai,
            textAlign: TextAlign.right,
            style: _gaya(size: 12, color: _abu),
          ),
        ),
      ],
    );
  }
}