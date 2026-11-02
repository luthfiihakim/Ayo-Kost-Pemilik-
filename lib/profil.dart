import 'package:flutter/material.dart';
import 'app_style.dart';
import 'bantuan_cs.dart';
import 'chat_list.dart';
import 'edit_profil.dart';
import 'halaman_ulasan.dart';
import 'informasi_riwayat_booking.dart';
import 'login.dart';
import 'pengaturan_notifikasi.dart';
import 'profil_model.dart';
import 'ubah_kata_sandi.dart';

const _merah = Color(0xFFEB221E);
const _garis = Color(0xFFE5E7EB);

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  ProfilData _data = ProfilData.contoh;

  void _segera(String nama) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Halaman $nama belum dibuat')),
    );
  }

  void _buka(Widget halaman) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => halaman));
  }

  Future<void> _editProfil() async {
    final hasil = await Navigator.push<ProfilData>(
      context,
      MaterialPageRoute(builder: (_) => EditProfilPage(data: _data)),
    );
    if (hasil != null && mounted) setState(() => _data = hasil);
  }

  Future<void> _keluar() async {
    final yakin = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const _KonfirmasiKeluar(),
    );
    if (yakin == true && mounted) {
      // TODO: hapus sesi / token login di sini.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: kBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: top + 202,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: top + 151,
                    padding: EdgeInsets.only(top: top + 34),
                    alignment: Alignment.topCenter,
                    decoration: const BoxDecoration(
                      color: kTeal,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Text(
                      'Profil',
                      style: poppins(
                          size: 22, weight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: top + 96,
                    left: 16,
                    right: 16,
                    height: 106,
                    child: _KartuProfil(data: _data, onEdit: _editProfil),
                  ),
                ],
              ),
            ),
            const _JudulBagian('AKTIVITAS', atas: 15),
            _KartuMenu(
              baris: [
                _BarisMenu(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Riwayat Penarikan',
                  onTap: () => _segera('Riwayat Penarikan'),
                ),
                _BarisMenu(
                  icon: Icons.star_border,
                  label: 'Ulasan Saya',
                  onTap: () => _buka(const HalamanUlasan()),
                ),
              ],
            ),
            const _JudulBagian('PENGATURAN', atas: 22),
            _KartuMenu(
              baris: [
                _BarisMenu(
                  icon: Icons.notifications_none,
                  label: 'Notifikasi',
                  onTap: () => _buka(const PengaturanNotifikasiPage()),
                ),
                _BarisMenu(
                  icon: Icons.lock_outline,
                  label: 'Ubah Kata Sandi',
                  onTap: () => _buka(const UbahKataSandiPage()),
                ),
                _BarisMenu(
                  icon: Icons.headset_mic_outlined,
                  label: 'Bantuan & CS',
                  onTap: () => _buka(const BantuanCsPage()),
                ),
                _BarisMenu(
                  icon: Icons.logout,
                  label: 'Keluar',
                  warna: Colors.red,
                  tanpaPanah: true,
                  onTap: _keluar,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        index: 4,
        onTap: (i) {
          if (i == 4) return; // sedang di Profil
          if (i == 2) {
            Navigator.maybePop(context); // kembali ke Beranda
          } else if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const InformasiRiwayatBookingPage(),
              ),
            );
          } else if (i == 1) {
            _buka(const HalamanUlasan());
          } else if (i == 3) {
            _buka(const ChatListPage());
          }
        },
      ),
    );
  }
}

class _JudulBagian extends StatelessWidget {
  final String teks;
  final double atas;
  const _JudulBagian(this.teks, {required this.atas});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(21, atas, 21, 3),
      child: Text(teks, style: poppins(size: 16, weight: FontWeight.w600)),
    );
  }
}

class _KartuProfil extends StatelessWidget {
  final ProfilData data;
  final VoidCallback onEdit;
  const _KartuProfil({required this.data, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: kCardShadow,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 11, 90, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: kTealLight,
                  // TODO: ganti dengan foto profil (NetworkImage / FileImage).
                  child: Icon(Icons.person, size: 44, color: kTeal),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: poppins(size: 18, weight: FontWeight.w600),
                      ),
                      _Info(Icons.person_outline, data.jenisKelamin),
                      _Info(Icons.phone_outlined, data.noHpTersamar),
                      _Info(Icons.location_on_outlined, data.alamat),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: 34,
            child: Material(
              color: const Color(0xBC95D2D2),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onEdit,
                child: SizedBox(
                  width: 73,
                  height: 44,
                  child: Center(
                    child: Text(
                      'Edit Profil',
                      style: poppins(
                          size: 12, weight: FontWeight.w600, color: kTeal),
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

class _Info extends StatelessWidget {
  final IconData icon;
  final String teks;
  const _Info(this.icon, this.teks);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(icon, size: 14, color: kTextDark),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              teks,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: poppins(size: 12, weight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuMenu extends StatelessWidget {
  final List<Widget> baris;
  const _KartuMenu({required this.baris});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: kCardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            for (var i = 0; i < baris.length; i++) ...[
              baris[i],
              if (i < baris.length - 1)
                const Divider(height: 1, thickness: 1, color: _garis),
            ],
          ],
        ),
      ),
    );
  }
}

class _BarisMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? warna;
  final bool tanpaPanah;

  const _BarisMenu({
    required this.icon,
    required this.label,
    required this.onTap,
    this.warna,
    this.tanpaPanah = false,
  });

  @override
  Widget build(BuildContext context) {
    final warnaIkon = warna ?? kTeal;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 46,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            children: [
              SizedBox(
                width: 35,
                child: Icon(icon, size: 24, color: warnaIkon),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  label,
                  style: poppins(
                    size: 14,
                    weight: FontWeight.w600,
                    color: warna ?? Colors.black,
                  ),
                ),
              ),
              if (!tanpaPanah)
                const Icon(Icons.chevron_right, size: 24, color: Colors.black87),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet "Anda yakin ingin keluar dari akun?"
class _KonfirmasiKeluar extends StatelessWidget {
  const _KonfirmasiKeluar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 25, 14, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: Color(0xFFFEC7C7),
                shape: BoxShape.circle,
                boxShadow: kCardShadow,
              ),
              child: const Icon(Icons.logout, size: 44, color: _merah),
            ),
            const SizedBox(height: 16),
            Text(
              'Anda yakin ingin keluar dari akun?',
              textAlign: TextAlign.center,
              style: poppins(size: 16, weight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _TombolSheet(
              label: 'Ya, Keluar',
              warna: _merah,
              warnaTeks: Colors.white,
              onTap: () => Navigator.pop(context, true),
            ),
            const SizedBox(height: 12),
            _TombolSheet(
              label: 'Tidak',
              warna: const Color(0xFFF4F7FC),
              warnaTeks: Colors.black,
              garis: kTeal,
              onTap: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
  }
}

class _TombolSheet extends StatelessWidget {
  final String label;
  final Color warna;
  final Color warnaTeks;
  final Color? garis;
  final VoidCallback onTap;

  const _TombolSheet({
    required this.label,
    required this.warna,
    required this.warnaTeks,
    required this.onTap,
    this.garis,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(12),
        border: garis == null ? null : Border.all(color: garis!),
        boxShadow: kCardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: poppins(size: 16, weight: FontWeight.w600, color: warnaTeks),
            ),
          ),
        ),
      ),
    );
  }
}