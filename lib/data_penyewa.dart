import 'package:flutter/material.dart';
import 'detail_penyewa.dart';

const _teal = Color(0xFF0F9D9D);
const _tealDark = Color(0xFF156D6D);
const _tealLight = Color(0xFFD9F1F1);
const _background = Color(0xFFE6F8F8);
const _greyNav = Color(0xFF797979);
const _greyText = Color(0xFF374151);

const _cardShadow = [
  BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4)),
];

TextStyle _poppins({
  required double size,
  FontWeight weight = FontWeight.w500,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontFamily: 'Poppins',
    fontSize: size,
    fontWeight: weight,
    color: color,
  );
}

class Penyewa {
  final String nama;
  final String kost;
  final String kamar;
  final String noHp;
  final String noBooking;
  final String mulai;
  final String periode;
  final String metodeBayar;
  final String total;
  final String catatan;

  const Penyewa({
    required this.nama,
    required this.kost,
    required this.kamar,
    required this.noHp,
    required this.noBooking,
    required this.mulai,
    required this.periode,
    required this.metodeBayar,
    required this.total,
    required this.catatan,
  });

  String get inisial => nama.isEmpty ? '?' : nama[0].toUpperCase();
}

// Data contoh (sesuaikan dengan isi Figma / ganti dengan data dari API nanti)
const _daftarPenyewa = [
  Penyewa(
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
  Penyewa(
    nama: 'Fuad Hanif',
    kost: 'Kost Mahogani',
    kamar: 'Kamar 2',
    noHp: '+62 813 3456 7890',
    noBooking: 'BK20251012',
    mulai: '27 Okt 2026',
    periode: '6 bulan',
    metodeBayar: 'Transfer bank',
    total: 'Rp 4.800.000',
    catatan: 'Mohon kamar lantai 1 jika tersedia.',
  ),
  Penyewa(
    nama: 'Naila Lidya',
    kost: 'Kost Meranti',
    kamar: 'Kamar 1',
    noHp: '+62 813 3456 7890',
    noBooking: 'BK20251013',
    mulai: '27 Okt 2026',
    periode: '6 bulan',
    metodeBayar: 'Transfer bank',
    total: 'Rp 4.800.000',
    catatan: 'Mohon kamar lantai 1 jika tersedia.',
  ),
  Penyewa(
    nama: 'Ashwa Arfika',
    kost: 'Kost Meranti',
    kamar: 'Kamar 2',
    noHp: '+62 813 3456 7890',
    noBooking: 'BK20251014',
    mulai: '27 Okt 2026',
    periode: '6 bulan',
    metodeBayar: 'Transfer bank',
    total: 'Rp 4.800.000',
    catatan: 'Mohon kamar lantai 1 jika tersedia.',
  ),
];

const _pilihanFilter = ['Semua', 'Kost Mahogani', 'Kost Meranti'];

class DataPenyewaPage extends StatefulWidget {
  const DataPenyewaPage({super.key});

  @override
  State<DataPenyewaPage> createState() => _DataPenyewaPageState();
}

class _DataPenyewaPageState extends State<DataPenyewaPage> {
  String _filterTerpilih = _pilihanFilter.first;
  int _navIndex = 2; // 0 Booking, 1 Ulasan, 2 Beranda, 3 Chat, 4 Profil

  List<Penyewa> get _penyewaTampil {
    if (_filterTerpilih == 'Semua') return _daftarPenyewa;
    return _daftarPenyewa.where((p) => p.kost == _filterTerpilih).toList();
  }

  void _bukaDetail(Penyewa penyewa) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPenyewaPage(penyewa: penyewa)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _penyewaTampil;

    return Scaffold(
      backgroundColor: _background,
      body: Column(
        children: [
          const _Header(title: 'Data Penyewa'),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
            child: _FilterTabs(
              pilihan: _pilihanFilter,
              terpilih: _filterTerpilih,
              onChanged: (v) => setState(() => _filterTerpilih = v),
            ),
          ),
          Expanded(
            child: data.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada penyewa',
                      style: _poppins(size: 14, color: _greyText),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                    itemCount: data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, i) => _PenyewaCard(
                      penyewa: data[i],
                      onLihatDetail: () => _bukaDetail(data[i]),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        index: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _teal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        boxShadow: _cardShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 20, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: _poppins(
                  size: 20,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ).copyWith(
                  shadows: const [
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
}

class _FilterTabs extends StatelessWidget {
  final List<String> pilihan;
  final String terpilih;
  final ValueChanged<String> onChanged;

  const _FilterTabs({
    required this.pilihan,
    required this.terpilih,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < pilihan.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _FilterChipItem(
              label: pilihan[i],
              aktif: pilihan[i] == terpilih,
              onTap: () => onChanged(pilihan[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool aktif;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: aktif ? _teal : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _teal),
          boxShadow: _cardShadow,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _poppins(
            size: aktif ? 14 : 12,
            weight: FontWeight.w600,
            color: aktif ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class _PenyewaCard extends StatelessWidget {
  final Penyewa penyewa;
  final VoidCallback onLihatDetail;

  const _PenyewaCard({required this.penyewa, required this.onLihatDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _cardShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: _tealLight,
            child: Text(
              penyewa.inisial,
              style: _poppins(
                size: 24,
                weight: FontWeight.w700,
                color: _tealDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  penyewa.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _poppins(size: 16, weight: FontWeight.w600),
                ),
                Text(
                  '${penyewa.kost} ·\n${penyewa.kamar}',
                  style: _poppins(size: 14, color: _greyText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: _tealLight,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onLihatDetail,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Text(
                  'Lihat Detail',
                  style: _poppins(
                    size: 14,
                    weight: FontWeight.w700,
                    color: _tealDark,
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

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: BottomNavigationBar(
        currentIndex: index,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _teal,
        unselectedItemColor: _greyNav,
        selectedLabelStyle: _poppins(size: 12, weight: FontWeight.w600),
        unselectedLabelStyle: _poppins(size: 12, weight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined), label: 'Booking'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border), label: 'Ulasan'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}