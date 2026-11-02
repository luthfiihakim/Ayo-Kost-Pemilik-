import 'package:flutter/material.dart';
import 'app_style.dart';
import 'halaman_dashboard.dart';

class DetailBookingPage extends StatelessWidget {
  final String noBooking;
  final String tanggalBooking;
  final String durasiSewa;
  final String statusPembayaran;
  final String tanggalMulaiSewa;
  final String tanggalBerakhirSewa;
  final String namaKos;
  final String alamat;
  final String namaPenyewa;
  final String noHp;
  final String? kamar;

  const DetailBookingPage({
    super.key,
    this.noBooking = 'BK20251010',
    this.tanggalBooking = '20 Okt 2026',
    this.durasiSewa = '6 bulan',
    this.statusPembayaran = 'Lunas',
    this.tanggalMulaiSewa = '20 Okt 2026',
    this.tanggalBerakhirSewa = '20 Apr 2027',
    this.namaKos = 'Kost Meranti',
    this.alamat = 'Reulet',
    this.namaPenyewa = 'Rina',
    this.noHp = '0812 3456 7890',
    this.kamar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F8),
      body: Column(
        children: [
          // 1. Header Custom
          _buildHeader(context),

          // 2. Konten Detail (Bisa di-scroll)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // Kartu 1: Informasi Booking
                  _buildCardSection(
                    title: 'Informasi Booking',
                    items: [
                      _buildRowItem('No. Booking', noBooking),
                      _buildRowItem('Tanggal Booking', tanggalBooking),
                      _buildRowItem('Durasi Sewa', durasiSewa),
                      _buildStatusRowItem('Status Pembayaran', statusPembayaran),
                      _buildRowItem('Tanggal Mulai Sewa', tanggalMulaiSewa),
                      _buildRowItem('Tanggal Berakhir Sewa', tanggalBerakhirSewa),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Kartu 2: Informasi Kost
                  _buildCardSection(
                    title: 'Informasi Kost',
                    items: [
                      _buildRowItem('Nama Kost', namaKos),
                      _buildRowItem('Alamat', alamat),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Kartu 3: Informasi Penyewa
                  _buildCardSection(
                    title: 'Informasi Penyewa',
                    items: [
                      _buildRowItem('Nama', namaPenyewa),
                      _buildRowItem('No. HP', noHp),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        index: 0,
        onTap: (i) {
          if (i == 0) {
            // Kembali ke riwayat/informasi booking
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          } else if (i == 2) {
            // Kembali ke Beranda (Dashboard)
            if (Navigator.canPop(context)) {
              Navigator.popUntil(context, (route) => route.isFirst);
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

  // Header Sesuai Gambar Figma
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0F9D9D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 16, 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              const Text(
                'Informasi Booking',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      color: Color(0x40000000),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Pembungkus Card Putih dengan Divider antar item
  Widget _buildCardSection({
    required String title,
    required List<Widget> items,
  }) {
    List<Widget> childrenWithDividers = [];
    for (int i = 0; i < items.length; i++) {
      childrenWithDividers.add(items[i]);
      if (i < items.length - 1) {
        childrenWithDividers.add(
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEEEEEE),
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0F9D9D),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...childrenWithDividers,
        ],
      ),
    );
  }

  // Widget Baris Item Biasa
  Widget _buildRowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Widget Baris Item Khusus Status (Badge Lunas)
  Widget _buildStatusRowItem(String label, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF7CBFB9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Color(0xFF0D4B4B),
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
