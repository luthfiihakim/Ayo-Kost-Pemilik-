import 'package:flutter/material.dart';
import 'app_style.dart';
import 'data_penyewa.dart';
import 'detail_penyewa.dart';

// Warna khusus halaman ini (di luar app_style.dart).
const _tabAktif = Color(0xED108686);
const _tabBorder = Color(0xFFC5C5C5);
const _belumDibaca = Color(0x3D95D2D2);

enum _Tab { semua, booking, pesan, lainnya }

enum _Bagian { hariIni, mingguIni }

enum _Jenis { bookingBaru, pembayaran, ulasan, sewaBerakhir, pesan }

class _Notif {
  final _Jenis jenis;
  final String judul;
  final String isi;
  final String waktu;
  final _Bagian bagian;
  final _Tab tab; // tab tempat notifikasi ini muncul (selain "Semua")
  bool belumDibaca;

  _Notif({
    required this.jenis,
    required this.judul,
    required this.isi,
    required this.waktu,
    required this.bagian,
    required this.tab,
    this.belumDibaca = false,
  });
}

class _Gaya {
  final Color latar;
  final Color ikonWarna;
  final IconData ikon;
  const _Gaya(this.latar, this.ikonWarna, this.ikon);
}

// Warna lingkaran sesuai Figma. Ikon memakai Material Icons.
const _gaya = <_Jenis, _Gaya>{
  _Jenis.bookingBaru: _Gaya(kTeal, Colors.white, Icons.receipt_long),
  _Jenis.pembayaran:
      _Gaya(Color(0xFF96CBFF), Color(0xFF1D4ED8), Icons.payments_outlined),
  _Jenis.ulasan: _Gaya(Color(0xFFFEF3C7), Color(0xFFF59E0B), Icons.star),
  _Jenis.sewaBerakhir:
      _Gaya(Color(0xFFFEC7C7), Color(0xFFDC2626), Icons.warning_amber_rounded),
  _Jenis.pesan: _Gaya(Colors.white, kTeal, Icons.chat_bubble_outline),
};

String _labelTab(_Tab t) {
  switch (t) {
    case _Tab.semua:
      return 'Semua';
    case _Tab.booking:
      return 'Booking';
    case _Tab.pesan:
      return 'Pesan';
    case _Tab.lainnya:
      return 'Lainnya';
  }
}

String _labelBagian(_Bagian b) =>
    b == _Bagian.hariIni ? 'Hari ini' : 'Minggu ini';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  _Tab _tab = _Tab.semua;

  // Isi notifikasi diambil dari teks di Figma. Ganti dengan data API nanti.
  final List<_Notif> _daftar = [
    _Notif(
      jenis: _Jenis.bookingBaru,
      judul: 'Booking Baru Masuk. ',
      isi: 'Luthfi Hakim memesan Kost Mahogani.\n'
          'Detail pemesanan telah diterima dan menunggu konfirmasi dari pemilik',
      waktu: '27 menit yang lalu',
      bagian: _Bagian.hariIni,
      tab: _Tab.booking,
      belumDibaca: true,
    ),
    _Notif(
      jenis: _Jenis.pembayaran,
      judul: 'Pembayaran diterima. ',
      isi: 'Pembayaran Kos Mahogani sebesar Rp 4.800.000 sudah kami terima.',
      waktu: '2 jam yang lalu',
      bagian: _Bagian.hariIni,
      tab: _Tab.booking,
      belumDibaca: true,
    ),
    _Notif(
      jenis: _Jenis.ulasan,
      judul: 'Ulasan Baru. ',
      isi: 'Luthfi Hakim memberi bintang 4,8.\n'
          '“Kamar bersih dan nyaman, pemiliknya ramah sekali !”.',
      waktu: '2 hari yang lalu',
      bagian: _Bagian.mingguIni,
      tab: _Tab.lainnya,
    ),
    _Notif(
      jenis: _Jenis.sewaBerakhir,
      judul: 'Sewa Segera Berakhir. ',
      isi: 'Kamar 1 berakhir 20 April 2027. Segera perpanjang sewa untuk '
          'menghindari pemesanan oleh orang lain.',
      waktu: '5 hari yang lalu',
      bagian: _Bagian.mingguIni,
      tab: _Tab.booking,
    ),
    _Notif(
      jenis: _Jenis.pesan,
      judul: 'Pemilik Kos Mahogani ',
      isi: 'mengirim pesan: “Halo pak, apakah kamar masih tersedia?.”',
      waktu: '6 hari yang lalu',
      bagian: _Bagian.mingguIni,
      tab: _Tab.pesan,
    ),
  ];

  bool get _adaBelumDibaca => _daftar.any((n) => n.belumDibaca);

  void _tandaiSemua() {
    setState(() {
      for (final n in _daftar) {
        n.belumDibaca = false;
      }
    });
  }

  void _buka(_Notif n) {
    setState(() => n.belumDibaca = false);
    if (n.jenis == _Jenis.bookingBaru) {
      // Data contoh yang sama dengan Luthfi Hakim di data_penyewa.dart.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const DetailPenyewaPage(
            penyewa: Penyewa(
              nama: 'Luthfi Hakim',
              kost: 'Kost Mahogani',
              kamar: 'Kamar 1',
              noHp: '+62 813 3456 7890',
              noBooking: 'BK20251011',
              mulai: '27 Okt 2026',
              periode: '6 bulan',
              metodeBayar: 'Transfer bank',
              total: 'Rp 4.800.000',
              catatan: 'Mohon kamar lantai 1 jika tersedia.',
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tampil = _daftar
        .where((n) => _tab == _Tab.semua || n.tab == _tab)
        .toList();

    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          _Header(adaBelumDibaca: _adaBelumDibaca, onTandaiSemua: _tandaiSemua),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 13, 15, 0),
            child: _TabBar(
              terpilih: _tab,
              onPilih: (t) => setState(() => _tab = t),
            ),
          ),
          Expanded(
            child: tampil.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada notifikasi',
                      style: poppins(size: 13, color: kGreyNav),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    children: [
                      for (final bagian in _Bagian.values)
                        ..._bagian(bagian, tampil),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _bagian(_Bagian bagian, List<_Notif> tampil) {
    final baris = tampil.where((n) => n.bagian == bagian).toList();
    if (baris.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(24, 11, 24, 8),
        child: Text(
          _labelBagian(bagian),
          style: poppins(size: 16, weight: FontWeight.w600),
        ),
      ),
      for (final n in baris) _BarisNotif(notif: n, onTap: () => _buka(n)),
    ];
  }
}

class _Header extends StatelessWidget {
  final bool adaBelumDibaca;
  final VoidCallback onTandaiSemua;

  const _Header({required this.adaBelumDibaca, required this.onTandaiSemua});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kTeal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 14, 9, 22),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 22),
              ),
              Text(
                'Notifikasi',
                style: poppins(
                    size: 20, weight: FontWeight.w600, color: Colors.white),
              ),
              const Spacer(),
              Flexible(
                child: Opacity(
                  opacity: adaBelumDibaca ? 1 : 0.6,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: adaBelumDibaca ? onTandaiSemua : null,
                    child: Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, 0.69),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Tandai Telah Dibaca',
                          maxLines: 1,
                          style: poppins(size: 14, weight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final _Tab terpilih;
  final ValueChanged<_Tab> onPilih;

  const _TabBar({required this.terpilih, required this.onPilih});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _tabBorder),
      ),
      child: Row(
        children: [
          for (final t in _Tab.values)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onPilih(t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: t == terpilih ? _tabAktif : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _labelTab(t),
                      maxLines: 1,
                      style: poppins(
                        size: 16,
                        weight: FontWeight.w600,
                        color: t == terpilih ? Colors.white : kTextDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BarisNotif extends StatelessWidget {
  final _Notif notif;
  final VoidCallback onTap;

  const _BarisNotif({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final gaya = _gaya[notif.jenis]!;

    return Material(
      color: notif.belumDibaca ? _belumDibaca : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(21, 10, 13, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 41,
                height: 41,
                decoration:
                    BoxDecoration(color: gaya.latar, shape: BoxShape.circle),
                child: Icon(gaya.ikon, size: 24, color: gaya.ikonWarna),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: notif.judul,
                            style: poppins(size: 12, weight: FontWeight.w600)
                                .copyWith(height: 1.35),
                          ),
                          TextSpan(
                            text: notif.isi,
                            style: poppins(size: 12, weight: FontWeight.w400)
                                .copyWith(height: 1.35),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif.waktu,
                      style: poppins(
                          size: 9, weight: FontWeight.w600, color: kGreyNav),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14, left: 8),
                child: SizedBox(
                  width: 13,
                  height: 13,
                  child: notif.belumDibaca
                      ? const DecoratedBox(
                          decoration: BoxDecoration(
                            color: kTeal,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}