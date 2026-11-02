class Kos {
  final String id;
  final String nama;
  final String kawasan;
  final String alamat;
  final int harga; // per bulan
  final int jumlahKamar;
  final int kamarTersedia;
  final List<String> fasilitas;
  final String deskripsi;

  /// Daftar path asset foto (untuk carousel di halaman detail).
  /// Contoh: ['assets/images/mahogani_1.jpg', 'assets/images/mahogani_2.jpg']
  /// Foto pertama dipakai sebagai thumbnail di halaman Kost Saya.
  final List<String> foto;
  final bool aktif;

  const Kos({
    required this.id,
    required this.nama,
    required this.kawasan,
    required this.alamat,
    required this.harga,
    required this.jumlahKamar,
    required this.kamarTersedia,
    required this.fasilitas,
    this.deskripsi = '',
    this.foto = const [],
    this.aktif = true,
  });

  String? get fotoUtama => foto.isEmpty ? null : foto.first;

  Kos copyWith({
    String? nama,
    String? alamat,
    int? harga,
    int? jumlahKamar,
    int? kamarTersedia,
    List<String>? fasilitas,
    String? deskripsi,
    List<String>? foto,
  }) {
    return Kos(
      id: id,
      nama: nama ?? this.nama,
      kawasan: kawasan,
      alamat: alamat ?? this.alamat,
      harga: harga ?? this.harga,
      jumlahKamar: jumlahKamar ?? this.jumlahKamar,
      kamarTersedia: kamarTersedia ?? this.kamarTersedia,
      fasilitas: fasilitas ?? this.fasilitas,
      deskripsi: deskripsi ?? this.deskripsi,
      foto: foto ?? this.foto,
      aktif: aktif,
    );
  }
}

// Data contoh (ganti dengan data dari API nanti)
const kosContoh = [
  Kos(
    id: 'mahogani',
    nama: 'Kost Mahogani',
    kawasan: 'Reulet',
    alamat: 'Jl. Mahogani dekat dengan kampus',
    harga: 750000,
    jumlahKamar: 20,
    kamarTersedia: 20,
    fasilitas: [
      'AC',
      'Kasur',
      'Meja',
      'Lemari',
      'Jendela',
      'Tempat Tidur',
      'Kursi',
      'Wifi',
    ],
    // Hapus tanda // setelah foto dimasukkan ke assets & pubspec.yaml
    // foto: [
    //   'assets/images/mahogani_1.jpg',
    //   'assets/images/mahogani_2.jpg',
    //   'assets/images/mahogani_3.jpg',
    // ],
  ),
  Kos(
    id: 'meranti',
    nama: 'Kost Meranti',
    kawasan: 'Reulet',
    alamat: 'Jl. Meranti dekat dengan kampus',
    harga: 750000,
    jumlahKamar: 20,
    kamarTersedia: 16,
    fasilitas: [
      'AC',
      'Kasur',
      'Meja',
      'Lemari',
      'Jendela',
      'Tempat Tidur',
      'Kursi',
      'Wifi',
    ],
    // foto: [
    //   'assets/images/meranti_1.jpg',
    //   'assets/images/meranti_2.jpg',
    //   'assets/images/meranti_3.jpg',
    // ],
  ),
];