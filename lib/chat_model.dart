class Pesan {
  final String? teks;
  final bool dariSaya;
  final String waktu;
  final int? durasiVoice; // detik; kalau tidak null berarti voice note
  final List<double> gelombang; // 0..1, untuk tampilan voice note

  const Pesan({
    this.teks,
    required this.dariSaya,
    required this.waktu,
    this.durasiVoice,
    this.gelombang = const [],
  });

  bool get voiceNote => durasiVoice != null;
}

class Percakapan {
  final String nama;
  final List<Pesan> pesan;

  Percakapan({required this.nama, List<Pesan>? pesan})
      : pesan = pesan ?? <Pesan>[];

  /// "Luthfi Hakim" -> "LH", "Rina" -> "R"
  String get inisial {
    final kata = nama
        .trim()
        .split(RegExp(r'\s+'))
        .where((k) => k.isNotEmpty)
        .toList();
    if (kata.isEmpty) return '?';
    if (kata.length == 1) return kata[0][0].toUpperCase();
    return (kata[0][0] + kata[1][0]).toUpperCase();
  }

  Pesan? get terakhir => pesan.isEmpty ? null : pesan.last;
}

String waktuSekarang() {
  final n = DateTime.now();
  return '${n.hour.toString().padLeft(2, '0')}:'
      '${n.minute.toString().padLeft(2, '0')}';
}

/// 65 -> "1:05"
String formatDurasi(int detik) {
  final m = detik ~/ 60;
  final s = (detik % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

// ---------------------------------------------------------------------------
// Data sementara di memori (hilang saat aplikasi ditutup).
// Nanti ganti dengan data dari backend.
// ---------------------------------------------------------------------------
const _tanyaKos = 'Halo pak, Apakah Ada kos kosong?';
const _tanyaSurvei = 'Boleh survei hari Sabtu pak?';

final List<Percakapan> daftarPercakapan = [
  Percakapan(nama: 'Luthfi Hakim', pesan: [
    const Pesan(teks: _tanyaKos, dariSaya: false, waktu: '16:25'),
  ]),
  Percakapan(nama: 'Fuad Hanif', pesan: [
    const Pesan(teks: _tanyaSurvei, dariSaya: false, waktu: '13:15'),
  ]),
  Percakapan(nama: 'Ashwa Arfika', pesan: [
    const Pesan(teks: _tanyaKos, dariSaya: false, waktu: '12:25'),
  ]),
  Percakapan(nama: 'Naila Lidya', pesan: [
    const Pesan(teks: _tanyaSurvei, dariSaya: false, waktu: '12:15'),
  ]),
  Percakapan(nama: 'Rina', pesan: [
    const Pesan(teks: _tanyaKos, dariSaya: false, waktu: '10:25'),
  ]),
  Percakapan(nama: 'Safa', pesan: [
    const Pesan(teks: _tanyaSurvei, dariSaya: false, waktu: '08:25'),
  ]),
  Percakapan(nama: 'Wulan', pesan: [
    const Pesan(teks: _tanyaKos, dariSaya: false, waktu: 'Kemarin'),
  ]),
  Percakapan(nama: 'Cahya', pesan: [
    const Pesan(teks: _tanyaSurvei, dariSaya: false, waktu: 'Kemarin'),
  ]),
];

/// Dipakai tombol "Chat Penyewa": buka percakapan yang ada, atau buat baru.
Percakapan cariAtauBuatPercakapan(String nama) {
  for (final p in daftarPercakapan) {
    if (p.nama.toLowerCase() == nama.toLowerCase()) return p;
  }
  final baru = Percakapan(nama: nama);
  daftarPercakapan.insert(0, baru);
  return baru;
}