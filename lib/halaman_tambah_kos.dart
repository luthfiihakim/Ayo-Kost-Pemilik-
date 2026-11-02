import 'package:flutter/material.dart';

class HalamanTambahKos extends StatefulWidget {
  const HalamanTambahKos({Key? key}) : super(key: key);

  @override
  State<HalamanTambahKos> createState() => _HalamanTambahKosState();
}

class _HalamanTambahKosState extends State<HalamanTambahKos> {
  // State untuk kategori kos yang dipilih (Laki-laki, Perempuan, Campur)
  String selectedKategori = 'Campur';

  // Controller untuk mengambil data dari input form (opsional jika ingin disimpan)
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _kamarController = TextEditingController();
  final TextEditingController _fasilitasController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // Fungsi untuk memunculkan pilihan Kamera atau Galeri
  void _tampilkanPilihanSumberFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Sumber Foto',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF0F9D9D)),
                title: const Text('Ambil dari Kamera', style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Tambahkan logika kamera di sini
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF0F9D9D)),
                title: const Text('Pilih dari Galeri', style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Tambahkan logika galeri di sini
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi ketika tombol Simpan ditekan
  void _simpanDataKos() {
    // Contoh validasi sederhana atau aksi simpan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data kos berhasil disimpan!')),
    );
    // Kembali ke halaman sebelumnya setelah disimpan
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header / App Bar Custom dengan Tombol Kembali
            Container(
              width: double.infinity,
              height: 84,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const ShapeDecoration(
                color: Color(0xFF0F9D9D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Tombol Kembali di sebelah kiri
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Kembali ke halaman sebelumnya
                      },
                    ),
                  ),
                  // Judul di tengah
                  Text(
                    'Tambah Kos Baru',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                          color: const Color(0xFF000000).withOpacity(0.25),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bagian Form yang Bisa Di-scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Unggah Foto Kost
                    Text(
                      'Foto Kost',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _tampilkanPilihanSumberFoto,
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 2,
                              color: Color(0xFF0F9D9D),
                            ),
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
                        child: Center(
                          child: Text(
                            '+ Unggah foto kost',
                            style: TextStyle(
                              color: const Color(0xFF0F9D9D),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. Nama Kost
                    Text(
                      'Nama kost',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Kost Mahogani',
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFDBDBDB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF0F9D9D)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Kategori Kost (Pilihan)
                    Text(
                      'Kategori Kost',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildKategoriButton('Laki laki'),
                        const SizedBox(width: 8),
                        _buildKategoriButton('Perempuan'),
                        const SizedBox(width: 8),
                        _buildKategoriButton('Campur'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 4. Alamat Lengkap
                    Text(
                      'Alamat lengkap',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _alamatController,
                      decoration: InputDecoration(
                        hintText: 'Jalan, kecamatan, kota',
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 15,
                          fontFamily: 'Raleway',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFDBDBDB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF0F9D9D)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 5. Harga & Jumlah Kamar (Sejajar)
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Harga / Bulan',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _hargaController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFAAAAAA),
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFDBDBDB)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0F9D9D)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jumlah kamar',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _kamarController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFFAAAAAA),
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFDBDBDB)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0F9D9D)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 6. Fasilitas
                    Text(
                      'Fasilitas',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _fasilitasController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            'Ketik fasilitas kos anda disini, contoh:\nAC\nKasur\nMeja Belajar',
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFDBDBDB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF0F9D9D)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 7. Deskripsi Kost
                    Text(
                      'Deskripsi Kost',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _deskripsiController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Deskripsikan kos anda disini',
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFDBDBDB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF0F9D9D)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Tombol Simpan di Bagian Bawah (Fixed Footer)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F9D9D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  onPressed: _simpanDataKos, // <-- Tombol simpan sekarang sudah berfungsi!
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Pendukung untuk Tombol Kategori
  Widget _buildKategoriButton(String title) {
    bool isSelected = selectedKategori == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedKategori = title;
          });
        },
        child: Container(
          height: 41,
          decoration: ShapeDecoration(
            color: isSelected ? const Color(0xFF0F9D9D) : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: isSelected ? const Color(0xFF0F9D9D) : const Color(0xFFDBDBDB),
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFAAAAAA),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}