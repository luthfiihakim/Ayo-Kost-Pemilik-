import 'package:flutter/material.dart';
import 'app_style.dart';
import 'kos_model.dart';
import 'edit_kos.dart';

class DetailKosPage extends StatefulWidget {
  final Kos kos;
  final ValueChanged<Kos> onUpdate;
  final VoidCallback onHapus;

  const DetailKosPage({
    super.key,
    required this.kos,
    required this.onUpdate,
    required this.onHapus,
  });

  @override
  State<DetailKosPage> createState() => _DetailKosPageState();
}

class _DetailKosPageState extends State<DetailKosPage> {
  late Kos _kos;

  @override
  void initState() {
    super.initState();
    _kos = widget.kos;
  }

  Future<void> _edit() async {
    final hasil = await Navigator.push<Kos>(
      context,
      MaterialPageRoute(builder: (_) => EditKosPage(kos: _kos)),
    );
    if (hasil == null || !mounted) return;
    setState(() => _kos = hasil);
    widget.onUpdate(hasil);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan disimpan')),
    );
  }

  Future<void> _hapus() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Hapus kost?',
            style: poppins(size: 16, weight: FontWeight.w700)),
        content: Text(
          '${_kos.nama} akan dihapus dari daftar kost Anda.',
          style: poppins(size: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Batal', style: poppins(size: 13, color: kGreyText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Hapus',
                style: poppins(
                    size: 13, weight: FontWeight.w700, color: Colors.red)),
          ),
        ],
      ),
    );
    if (yakin == true && mounted) {
      widget.onHapus();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: kPageGrey,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header teal + carousel foto yang menimpa header (sesuai Figma)
          SizedBox(
            height: top + 53 + 216,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: top + 106,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: kTeal,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(22)),
                      boxShadow: kCardShadow,
                    ),
                  ),
                ),
                Positioned(
                  top: top,
                  left: 8,
                  child: IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 22),
                  ),
                ),
                Positioned(
                  top: top + 53,
                  left: 0,
                  right: 0,
                  height: 216,
                  child: _KosCarousel(fotos: _kos.foto),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _kos.nama,
                        style: poppins(
                          size: 20,
                          weight: FontWeight.w700,
                          color: kTeal,
                        ),
                      ),
                      Text(
                        _kos.kawasan,
                        style: poppins(
                            size: 13, weight: FontWeight.w400, color: kTeal),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: kTeal),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _kos.alamat,
                              style: poppins(
                                  size: 11, weight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 72,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 206, child: _KotakHarga(harga: _kos.harga)),
                      const SizedBox(width: 14),
                      Expanded(
                        flex: 115,
                        child: _KotakKamar(tersedia: _kos.kamarTersedia),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const SizedBox(width: 2),
                    const Icon(Icons.auto_awesome, size: 22, color: kTeal),
                    const SizedBox(width: 10),
                    Text(
                      'Fasilitas',
                      style: poppins(
                          size: 15, weight: FontWeight.w400, color: kTeal),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: _DaftarFasilitas(items: _kos.fasilitas),
                ),
                if (_kos.deskripsi.trim().isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deskripsi',
                            style: poppins(
                                size: 15,
                                weight: FontWeight.w400,
                                color: kTeal)),
                        const SizedBox(height: 6),
                        Text(_kos.deskripsi,
                            style: poppins(
                                size: 12,
                                weight: FontWeight.w400,
                                color: kGreyText)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Hapus',
                  icon: Icons.delete_outline,
                  filled: false,
                  onPressed: _hapus,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: 'Edit kost',
                  icon: Icons.edit_outlined,
                  onPressed: _edit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Carousel foto (geser kiri/kanan, ada panah & indikator titik)
// ---------------------------------------------------------------------------
class _KosCarousel extends StatefulWidget {
  final List<String> fotos;
  const _KosCarousel({required this.fotos});

  @override
  State<_KosCarousel> createState() => _KosCarouselState();
}

class _KosCarouselState extends State<_KosCarousel> {
  final _controller = PageController();
  int _index = 0;

  int get _jumlah => widget.fotos.isEmpty ? 1 : widget.fotos.length;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _geser(int ke) {
    _controller.animateToPage(
      ke,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: _jumlah,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: KosFoto(
              asset: widget.fotos.isEmpty ? null : widget.fotos[i],
              radius: 30,
              shadow: true,
            ),
          ),
        ),
        if (_index > 0)
          Positioned(
            left: 18,
            top: 0,
            bottom: 0,
            child: Center(
              child: _TombolPanah(
                icon: Icons.chevron_left,
                onTap: () => _geser(_index - 1),
              ),
            ),
          ),
        if (_index < _jumlah - 1)
          Positioned(
            right: 18,
            top: 0,
            bottom: 0,
            child: Center(
              child: _TombolPanah(
                icon: Icons.chevron_right,
                onTap: () => _geser(_index + 1),
              ),
            ),
          ),
        if (_jumlah > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _jumlah; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _index ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _index ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TombolPanah extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _TombolPanah({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black26,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
class _KotakHarga extends StatelessWidget {
  final int harga;
  const _KotakHarga({required this.harga});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: kTealSoft,
        borderRadius: BorderRadius.circular(16),
        boxShadow: kCardShadow,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '${rupiah(harga)} / bulan',
          style: poppins(size: 20, weight: FontWeight.w700, color: kTealDark),
        ),
      ),
    );
  }
}

class _KotakKamar extends StatelessWidget {
  final int tersedia;
  const _KotakKamar({required this.tersedia});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: kCardShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Kamar Tersedia',
              maxLines: 1,
              style: poppins(size: 12, weight: FontWeight.w400)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bed_outlined, size: 24, color: kTealDark),
                const SizedBox(width: 4),
                Text('$tersedia',
                    style: poppins(size: 20, weight: FontWeight.w700)),
                const SizedBox(width: 4),
                Text('Kamar',
                    style: poppins(
                        size: 14,
                        weight: FontWeight.w400,
                        color: const Color(0xFF5D5353))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DaftarFasilitas extends StatelessWidget {
  final List<String> items;
  const _DaftarFasilitas({required this.items});

  Widget _kolom(List<String> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in data)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 4, color: kTeal),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item,
                      style: poppins(
                          size: 14, weight: FontWeight.w400, color: kTeal)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text('-', style: poppins(size: 14, color: kGreyText));
    }
    final kiri = items.take(5).toList();
    final kanan = items.skip(5).toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _kolom(kiri)),
        Expanded(child: _kolom(kanan)),
      ],
    );
  }
}