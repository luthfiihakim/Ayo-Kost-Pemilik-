import 'package:flutter/material.dart';
import 'app_style.dart';
import 'data_penyewa.dart';
import 'kos_saya.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 2; // Beranda aktif secara default

  void _bukaDataPenyewa() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DataPenyewaPage()),
    );
  }

  void _bukaKosSaya() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const KosSayaPage()),
    );
  }

  void _segera(String nama) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Halaman $nama belum dibuat')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: kBackground,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Header teal sampai ke status bar
            Container(
              height: top + 180,
              decoration: const BoxDecoration(
                color: kTeal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                boxShadow: kCardShadow,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sapaan, notifikasi, avatar
                Padding(
                  padding: EdgeInsets.fromLTRB(20, top + 20, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Halo, Hakim! 👋',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppins(
                            size: 22,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => _segera('Notifikasi'),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF34BABA),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(Icons.notifications_none,
                                      color: Colors.white, size: 26),
                                  Positioned(
                                    right: 9,
                                    top: 8,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE21818),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'H',
                              style: poppins(
                                size: 20,
                                weight: FontWeight.w700,
                                color: kTealDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Grid 4 kartu menu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _KartuMenu(
                              icon: Icons.add,
                              judul: 'Tambah Kos',
                              subjudul: 'Daftarkan kost baru',
                              onTap: () => _segera('Tambah Kos'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _KartuMenu(
                              icon: Icons.people_alt,
                              judul: 'Data Penyewa',
                              subjudul: '17 penyewa aktif',
                              onTap: _bukaDataPenyewa,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _KartuMenu(
                              icon: Icons.account_balance_wallet,
                              judul: 'Informasi Saldo',
                              subjudul: 'Penarikan & informasi\npendapatan',
                              onTap: () => _segera('Informasi Saldo'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _KartuMenu(
                              icon: Icons.home,
                              judul: 'Kos Saya',
                              subjudul: 'Lihat & atur kamar kost',
                              onTap: _bukaKosSaya,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Penyewa Terbaru',
                    style: poppins(size: 16, weight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: kCardShadow,
                  ),
                  child: const Column(
                    children: [
                      _BarisPenyewa(
                        nama: 'Lidya',
                        kamar: 'Kamar 3 • Kost Mahogani',
                        tanggal: '29 Sep – 28 Okt 2026',
                      ),
                      SizedBox(height: 20),
                      _BarisPenyewa(
                        nama: 'Naila',
                        kamar: 'Kamar 7 • Kost Meranti',
                        tanggal: '27 Sep – 26 Okt 2026',
                      ),
                      SizedBox(height: 20),
                      _BarisPenyewa(
                        nama: 'Ashwa',
                        kamar: 'Kamar 5 • Kost Meranti',
                        tanggal: '26 Sep – 25 Okt 2026',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        index: _selectedIndex,
        onTap: (i) {
          if (i == 2) return;
          _segera('ini'); // TODO: Booking, Ulasan, Chat, Profil
        },
      ),
    );
  }
}

class _KartuMenu extends StatelessWidget {
  final IconData icon;
  final String judul;
  final String subjudul;
  final VoidCallback onTap;

  const _KartuMenu({
    required this.icon,
    required this.judul,
    required this.subjudul,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 138,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: kCardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: kTeal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const Spacer(),
                Text(
                  judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppins(size: 14, weight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  subjudul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: poppins(
                    size: 11,
                    weight: FontWeight.w400,
                    color: Colors.black45,
                  ).copyWith(height: 1.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BarisPenyewa extends StatelessWidget {
  final String nama;
  final String kamar;
  final String tanggal;

  const _BarisPenyewa({
    required this.nama,
    required this.kamar,
    required this.tanggal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFFC5E7E7),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            nama[0].toUpperCase(),
            style: poppins(size: 18, weight: FontWeight.w700, color: kTealDark),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nama,
                style: poppins(size: 14, weight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                kamar,
                style: poppins(
                    size: 11, weight: FontWeight.w400, color: Colors.black45),
              ),
            ],
          ),
        ),
        Text(
          tanggal,
          style: poppins(
              size: 11, weight: FontWeight.w500, color: Colors.black54),
        ),
      ],
    );
  }
}