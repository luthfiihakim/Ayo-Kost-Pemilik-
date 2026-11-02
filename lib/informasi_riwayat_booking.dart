import 'package:flutter/material.dart';
import 'app_style.dart';
import 'detail_booking_page.dart';
import 'halaman_dashboard.dart';

class InformasiRiwayatBookingPage extends StatefulWidget {
  const InformasiRiwayatBookingPage({super.key});

  @override
  State<InformasiRiwayatBookingPage> createState() =>
      _InformasiRiwayatBookingPageState();
}

class _InformasiRiwayatBookingPageState
    extends State<InformasiRiwayatBookingPage> {
  int _selectedTab = 0;

  // Fungsi untuk membuka halaman Detail Booking
  void _bukaDetailBooking({
    String penyewa = 'Rina',
    String kos = 'Kost Meranti',
    String kamar = 'Kamar 1',
    String noBooking = 'BK20251010',
    String tanggalBooking = '20 Okt 2026',
    String durasi = '6 bulan',
    String status = 'Lunas',
    String mulai = '20 Okt 2026',
    String selesai = '20 Apr 2027',
    String alamat = 'Reulet',
    String noHp = '0812 3456 7890',
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBookingPage(
          noBooking: noBooking,
          tanggalBooking: tanggalBooking,
          durasiSewa: durasi,
          statusPembayaran: status,
          tanggalMulaiSewa: mulai,
          tanggalBerakhirSewa: selesai,
          namaKos: kos,
          alamat: alamat,
          namaPenyewa: penyewa,
          noHp: noHp,
          kamar: kamar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Custom
            Container(
              width: double.infinity,
              height: 89,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const ShapeDecoration(
                color: Color(0xFF0F9D9D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Booking',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Color(0x40000000),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Tombol Toggle Tab (Riwayat Booking & Informasi Booking)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: Container(
                height: 56,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedTab == 0
                                ? const Color(0xFF0F9D9D)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Riwayat Booking',
                            style: TextStyle(
                              color: _selectedTab == 0
                                  ? Colors.white
                                  : const Color(0xFF374151),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedTab == 1
                                ? const Color(0xFF0F9D9D)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Informasi Booking',
                            style: TextStyle(
                              color: _selectedTab == 1
                                  ? Colors.white
                                  : const Color(0xFF374151),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Daftar Konten Berdasarkan Tab
            Expanded(
              child: _selectedTab == 0
                  ? ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      children: [
                        _buildCardBooking(
                          namaKos: 'Kos Mahogani',
                          namaPenyewa: 'Luthfi Hakim',
                          tanggal: '20 Okt 2026 - 20 Apr 2027',
                          kamar: 'Kamar 1',
                          harga: 'Rp 500.000/bln',
                          status: 'Selesai',
                          onDetailPressed: () {
                            _bukaDetailBooking(
                              penyewa: 'Luthfi Hakim',
                              kos: 'Kos Mahogani',
                              kamar: 'Kamar 1',
                              noBooking: 'BK20251010',
                              tanggalBooking: '20 Okt 2026',
                              durasi: '6 bulan',
                              status: 'Lunas',
                              mulai: '20 Okt 2026',
                              selesai: '20 Apr 2027',
                              alamat: 'Reulet',
                              noHp: '0812 3456 7890',
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildCardBooking(
                          namaKos: 'Kos Mahogani',
                          namaPenyewa: 'Fuad Hanif',
                          tanggal: '20 Okt 2026 - 20 Apr 2027',
                          kamar: 'Kamar 3',
                          harga: 'Rp 500.000/bln',
                          status: 'Selesai',
                          onDetailPressed: () {
                            _bukaDetailBooking(
                              penyewa: 'Fuad Hanif',
                              kos: 'Kos Mahogani',
                              kamar: 'Kamar 3',
                              noBooking: 'BK20251011',
                              tanggalBooking: '20 Okt 2026',
                              durasi: '6 bulan',
                              status: 'Lunas',
                              mulai: '20 Okt 2026',
                              selesai: '20 Apr 2027',
                              alamat: 'Reulet',
                              noHp: '0821 9876 5432',
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      children: [
                        _buildCardBooking(
                          namaKos: 'Kost Meranti',
                          namaPenyewa: 'Rina',
                          tanggal: '20 Okt 2026 - 20 Apr 2027',
                          kamar: 'Kamar 2',
                          harga: 'Rp 650.000/bln',
                          status: 'Lunas',
                          onDetailPressed: () {
                            _bukaDetailBooking(
                              penyewa: 'Rina',
                              kos: 'Kost Meranti',
                              kamar: 'Kamar 2',
                              noBooking: 'BK20251010',
                              tanggalBooking: '20 Okt 2026',
                              durasi: '6 bulan',
                              status: 'Lunas',
                              mulai: '20 Okt 2026',
                              selesai: '20 Apr 2027',
                              alamat: 'Reulet',
                              noHp: '0812 3456 7890',
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        index: 0,
        onTap: (i) {
          if (i == 0) return; // Sudah di halaman Booking
          if (i == 2) {
            // Kembali ke Beranda (Dashboard)
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Dashboard()),
              );
            }
          } else {
            final menuNames = ['Booking', 'Ulasan', 'Beranda', 'Chat', 'Profil'];
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Halaman ${menuNames[i]} segera hadir'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }

  // Widget Komponen Kartu Riwayat Booking
  Widget _buildCardBooking({
    required String namaKos,
    required String namaPenyewa,
    required String tanggal,
    required String kamar,
    required String harga,
    required String status,
    required VoidCallback onDetailPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 178,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                namaKos,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                namaPenyewa,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tanggal,
                style: const TextStyle(
                  color: Color(0xFF797979),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    kamar,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    harga,
                    style: const TextStyle(
                      color: Color(0xFF156D6D),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Tombol Lihat Detail yang sudah dihubungkan ke onDetailPressed
              SizedBox(
                width: double.infinity,
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0x3F15B0B0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: onDetailPressed,
                  child: const Text(
                    'Lihat Detail',
                    style: TextStyle(
                      color: Color(0xFF035555),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Badge Status di pojok kanan atas kartu
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: ShapeDecoration(
                color: const Color(0x5B15B0B0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF156D6D),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
