/// Data profil pemilik. Ganti `contoh` dengan data akun asli / API nanti.
class ProfilData {
  final String nama;
  final String jenisKelamin;
  final String email;
  final String noHp;
  final String alamat;

  const ProfilData({
    required this.nama,
    required this.jenisKelamin,
    required this.email,
    required this.noHp,
    required this.alamat,
  });

  /// Data contoh dari Figma.
  static const contoh = ProfilData(
    nama: 'Fuad Hidayahtullah',
    jenisKelamin: 'Laki-laki',
    email: 'fuadfigma@gmail.com',
    noHp: '081234567890',
    alamat: 'Lhokseumawe',
  );

  /// Email tidak bisa diubah (kolomnya terkunci di Figma).
  ProfilData copyWith({
    String? nama,
    String? jenisKelamin,
    String? noHp,
    String? alamat,
  }) {
    return ProfilData(
      nama: nama ?? this.nama,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      email: email,
      noHp: noHp ?? this.noHp,
      alamat: alamat ?? this.alamat,
    );
  }

  /// 081234567890 -> 08*******890
  String get noHpTersamar {
    if (noHp.length <= 5) return noHp;
    final bintang = '*' * (noHp.length - 5);
    return '${noHp.substring(0, 2)}$bintang${noHp.substring(noHp.length - 3)}';
  }
}