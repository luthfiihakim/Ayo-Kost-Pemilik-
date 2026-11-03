import 'package:flutter/material.dart';
import 'chat_list.dart';
import 'halaman_dashboard.dart';
import 'halaman_ulasan.dart';
import 'informasi_riwayat_booking.dart';
import 'profil.dart';

/// Pindah tab navigasi bawah: 0 Booking, 1 Ulasan, 2 Beranda, 3 Chat, 4 Profil.
///
/// Tumpukan halaman dibersihkan dulu sampai tinggal Beranda, lalu tab tujuan
/// dibuka di atasnya. Jadi tombol kembali selalu ke Beranda dan halaman tidak
/// menumpuk saat pindah-pindah tab.
void pindahTab(BuildContext context, {required int dari, required int ke}) {
  if (dari == ke) return;
  final nav = Navigator.of(context);
  nav.pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const Dashboard()),
    (route) => false,
  );
  if (ke == 2) return; // Beranda
  nav.push(MaterialPageRoute(builder: (_) => _halamanTab(ke)));
}

Widget _halamanTab(int index) {
  switch (index) {
    case 0:
      return const InformasiRiwayatBookingPage();
    case 1:
      return const HalamanUlasan();
    case 3:
      return const ChatListPage();
    default:
      return const ProfilPage();
  }
}