import 'package:flutter/foundation.dart';

const kRouteSaldo = '/informasi-saldo';

String angka(int n) => n
    .toString()
    .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');

String rpTitik(int n) => 'Rp. ${angka(n)}';

String rpRapat(int n) => 'Rp${angka(n)}';

const _bulanPendek = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];
const _bulanPanjang = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

String _dua(int n) => n.toString().padLeft(2, '0');
String jam(DateTime d) => '${_dua(d.hour)}:${_dua(d.minute)}';

/// "20 Okt 2026"
String tglPendek(DateTime d) =>
    '${d.day} ${_bulanPendek[d.month - 1]} ${d.year}';

/// "21 Okt 2026 . 14:34"
String tglJam(DateTime d) => '${tglPendek(d)} . ${jam(d)}';

/// "17 Agu 2026, 07:25"
String tglWaktuPendek(DateTime d) => '${tglPendek(d)}, ${jam(d)}';

/// "17 Agustus 2026, 07:25:09 WIB"
String tglLengkap(DateTime d) =>
    '${d.day} ${_bulanPanjang[d.month - 1]} ${d.year}, '
    '${jam(d)}:${_dua(d.second)} WIB';


class Bank {
  final String nama; // untuk dropdown, contoh: "Bank BNI"
  final String namaLengkap; // untuk kartu rekening
  final String singkat; // contoh: "BNI"
  final int warna; // warna logo placeholder

  const Bank(this.nama, this.namaLengkap, this.singkat, this.warna);
}

const bankBca = Bank('Bank BCA', 'Bank Central Asia', 'BCA', 0xFF0060AF);
const bankBri = Bank('Bank BRI', 'Bank Rakyat Indonesia', 'BRI', 0xFF00529C);
const bankMandiri = Bank('Bank Mandiri', 'Bank Mandiri', 'Mandiri', 0xFF003D79);
const bankBni = Bank('Bank BNI', 'Bank Negara Indonesia', 'BNI', 0xFFF15A22);
const bankBsi =
    Bank('Bank BSI', 'Bank Syariah Indonesia', 'BSI', 0xFF00A39D);

const daftarBank = [bankBca, bankBri, bankMandiri, bankBni, bankBsi];

class Rekening {
  final Bank bank;
  final String nomor;
  final String nama;

  const Rekening(this.bank, this.nomor, this.nama);
}

class Penarikan {
  final String noRef;
  final Rekening rekening;
  final int jumlah;
  final int biayaAdmin;
  final DateTime waktu;
  final bool berhasil;

  Penarikan({
    required this.noRef,
    required this.rekening,
    required this.jumlah,
    required this.biayaAdmin,
    required this.waktu,
    required this.berhasil,
  });

  int get diterima => jumlah - biayaAdmin;
}

class Transaksi {
  final String judul;
  final DateTime tanggal;
  final int jumlah; 

  const Transaksi(this.judul, this.tanggal, this.jumlah);
}

class SaldoStore extends ChangeNotifier {
  SaldoStore._();
  static final SaldoStore instance = SaldoStore._();

  static const biayaAdmin = 2500;
  static const minPenarikan = 15000;
  
  bool paksaGagal = false;

  int saldo = 7000000; // saldo tersedia
  int saldoDiproses = 2600000; // menunggu persetujuan admin
  int get totalDompet => saldo + saldoDiproses;
  int pendapatanBulanIni = 5000000;
  int totalDitarik = 2400000;
  int jumlahPenarikan = 8;

  static const labelBulan = ['Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt'];
  final List<int> pendapatan6Bulan = [
    2400000, 3200000, 1800000, 3800000, 2800000, 4800000,
  ];

  final List<Rekening> rekening = [
    const Rekening(bankBsi, '7318609319', 'Muhammad Hakim'),
    const Rekening(bankBni, '20123456789', 'Luthfi Hakim'),
  ];

  // Terbaru di atas
  final List<Penarikan> riwayat = [
    Penarikan(
      noRef: '687542019283',
      rekening: const Rekening(bankBca, '4120098765', 'Muhammad Hakim'),
      jumlah: 2000000,
      biayaAdmin: biayaAdmin,
      waktu: DateTime(2026, 10, 30, 17, 34),
      berhasil: true,
    ),
    Penarikan(
      noRef: '687542011947',
      rekening: const Rekening(bankBsi, '7318609319', 'Muhammad Hakim'),
      jumlah: 1500000,
      biayaAdmin: biayaAdmin,
      waktu: DateTime(2026, 10, 27, 20, 30),
      berhasil: true,
    ),
    Penarikan(
      noRef: '687542005521',
      rekening: const Rekening(bankBri, '0123456789', 'Muhammad Hakim'),
      jumlah: 5000000,
      biayaAdmin: biayaAdmin,
      waktu: DateTime(2026, 10, 21, 14, 34),
      berhasil: true,
    ),
  ];

  final List<Transaksi> transaksi = [
    Transaksi('Penarikan ke BCA', DateTime(2026, 10, 30), -2000000),
    Transaksi('Penarikan ke BSI', DateTime(2026, 10, 27), -1500000),
    Transaksi('Kost Mahogani', DateTime(2026, 10, 20), 4800000),
  ];

  void tambahRekening(Rekening baru) {
    rekening.add(baru);
    notifyListeners();
  }

  String _noRef() => (DateTime.now().microsecondsSinceEpoch % 1000000000000)
      .toString()
      .padLeft(12, '0');

  /// Memproses penarikan. Mengembalikan [Penarikan] dengan status
  /// berhasil / gagal. Ganti isinya dengan panggilan API sungguhan.
  Future<Penarikan> tarik(Rekening tujuan, int jumlah) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final hasil = Penarikan(
      noRef: _noRef(),
      rekening: tujuan,
      jumlah: jumlah,
      biayaAdmin: biayaAdmin,
      waktu: DateTime.now(),
      berhasil: !paksaGagal,
    );

    if (hasil.berhasil) {
      saldo -= jumlah;
      totalDitarik += jumlah;
      jumlahPenarikan += 1;
      riwayat.insert(0, hasil);
      transaksi.insert(
        0,
        Transaksi('Penarikan ke ${tujuan.bank.singkat}', hasil.waktu, -jumlah),
      );
      notifyListeners();
    }
    return hasil;
  }
}