import 'package:flutter/material.dart';
import 'app_style.dart';
import 'kos_model.dart';
import 'detail_kos.dart';
import 'edit_kos.dart';

class KosSayaPage extends StatefulWidget {
  const KosSayaPage({super.key});

  @override
  State<KosSayaPage> createState() => _KosSayaPageState();
}

class _KosSayaPageState extends State<KosSayaPage> {
  late List<Kos> _daftarKos;

  @override
  void initState() {
    super.initState();
    _daftarKos = List.of(kosContoh);
  }

  void _perbarui(Kos baru) {
    setState(() {
      final i = _daftarKos.indexWhere((k) => k.id == baru.id);
      if (i != -1) _daftarKos[i] = baru;
    });
  }

  void _hapus(Kos kos) {
    setState(() => _daftarKos.removeWhere((k) => k.id == kos.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${kos.nama} dihapus')),
    );
  }

  void _bukaDetail(Kos kos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailKosPage(
          kos: kos,
          onUpdate: _perbarui,
          onHapus: () => _hapus(kos),
        ),
      ),
    );
  }

  Future<void> _bukaEdit(Kos kos) async {
    final hasil = await Navigator.push<Kos>(
      context,
      MaterialPageRoute(builder: (_) => EditKosPage(kos: kos)),
    );
    if (hasil != null && mounted) {
      _perbarui(hasil);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan disimpan')),
      );
    }
  }

  // Pilih kost mana yang mau diedit
  void _pilihKosUntukEdit() {
    if (_daftarKos.isEmpty) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Pilih kost yang ingin diedit',
                style: poppins(size: 14, weight: FontWeight.w700),
              ),
            ),
            for (final kos in _daftarKos)
              ListTile(
                leading: const Icon(Icons.home_work_outlined, color: kTeal),
                title: Text(kos.nama,
                    style: poppins(size: 14, weight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _bukaEdit(kos);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          const AppHeader(title: 'Kost Saya', radius: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(13, 19, 13, 24),
              children: [
                _BannerJumlah(jumlah: _daftarKos.length),
                const SizedBox(height: 25),
                if (_daftarKos.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Belum ada kost terdaftar',
                        style: poppins(size: 14, color: kGreyText),
                      ),
                    ),
                  )
                else
                  for (final kos in _daftarKos) ...[
                    _KosCard(kos: kos, onTap: () => _bukaDetail(kos)),
                    const SizedBox(height: 13),
                  ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 6),
                    const Icon(Icons.settings, size: 22, color: kTealDark),
                    const SizedBox(width: 12),
                    Text(
                      'Kelola Kost',
                      style: poppins(
                        size: 14,
                        weight: FontWeight.w700,
                        color: kTealDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _MenuKelola(
                  icon: Icons.edit_outlined,
                  label: 'Edit Informasi Kost',
                  onTap: _pilihKosUntukEdit,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        index: null,
        onTap: (i) {
          if (i == 2) Navigator.maybePop(context); // kembali ke Beranda
          // TODO: navigasi untuk Booking, Ulasan, Chat, Profil
        },
      ),
    );
  }
}

class _BannerJumlah extends StatelessWidget {
  final int jumlah;
  const _BannerJumlah({required this.jumlah});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: kBannerTeal,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.home, color: kTealDark, size: 36),
          const SizedBox(width: 12),
          Text(
            '$jumlah Kost Terdaftar',
            style: poppins(size: 14, weight: FontWeight.w600, color: kTealDark),
          ),
        ],
      ),
    );
  }
}

class _KosCard extends StatelessWidget {
  final Kos kos;
  final VoidCallback onTap;

  const _KosCard({required this.kos, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          child: Row(
            children: [
              KosFoto(
                asset: kos.fotoUtama,
                width: 120,
                height: 99,
                radius: 15,
                shadow: true,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: SizedBox(
                  height: 99,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kos.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: poppins(
                          size: 14,
                          weight: FontWeight.w700,
                          color: kTextDark,
                        ),
                      ),
                      Text(
                        '${rupiah(kos.harga)}/bulan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: poppins(
                          size: 13,
                          weight: FontWeight.w600,
                          color: kTealDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 18, color: kGreyNav),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              kos.kawasan,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: poppins(size: 12, color: kGreyNav),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 3),
                        decoration: BoxDecoration(
                          color: kBadgeTeal,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle,
                                size: 8,
                                color: kos.aktif ? kTealDark : kGreyNav),
                            const SizedBox(width: 6),
                            Text(
                              kos.aktif ? 'Aktif' : 'Nonaktif',
                              style: poppins(
                                size: 11,
                                color: kos.aktif ? kTealDark : kGreyNav,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _MenuKelola extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuKelola({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: kIconCircle,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: kTealDark),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  label,
                  style: poppins(
                    size: 14,
                    weight: FontWeight.w600,
                    color: kTextDark,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}