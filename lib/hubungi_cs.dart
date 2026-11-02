import 'package:flutter/material.dart';
import 'app_style.dart';

class _Pesan {
  final String teks;
  final bool dariSaya;
  const _Pesan(this.teks, {required this.dariSaya});
}

class HubungiCsPage extends StatefulWidget {
  const HubungiCsPage({super.key});

  @override
  State<HubungiCsPage> createState() => _HubungiCsPageState();
}

class _HubungiCsPageState extends State<HubungiCsPage> {
  final _isi = TextEditingController();
  final _scroll = ScrollController();

  // Percakapan contoh dari Figma. Ganti dengan data chat asli / API nanti.
  final List<_Pesan> _pesan = [
    const _Pesan(
      'Halo Min, bagaimana cara menarik saldo dari aplikasi Ayokost?',
      dariSaya: true,
    ),
    const _Pesan(
      'Halo Kak! Untuk menarik saldo, silahkan buka halaman Pendapatan, lalu '
      'pilih Tarik saldo. Setelah itu, pilih rekening tujuan dan masukkan '
      'nominal yang ingin di tarik.',
      dariSaya: false,
    ),
    const _Pesan(
      'Apakah saldo bisa langsung masuk ke rekening, Min?',
      dariSaya: true,
    ),
    const _Pesan(
      'Proses pencairan membutuhkan waktu sesuai ketentuan Ayokost. Kakak bisa '
      'melihat status dan riwayat penarikan.',
      dariSaya: false,
    ),
  ];

  @override
  void dispose() {
    _isi.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _kirim() {
    final teks = _isi.text.trim();
    if (teks.isEmpty) return;
    // TODO: kirim ke backend / layanan chat di sini.
    setState(() => _pesan.add(_Pesan(teks, dariSaya: true)));
    _isi.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          const _HeaderCs(),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(13, 16, 14, 16),
              itemCount: _pesan.length,
              itemBuilder: (_, i) => _Gelembung(pesan: _pesan[i]),
            ),
          ),
          _KolomKetik(
            controller: _isi,
            onKirim: _kirim,
            onChanged: () => setState(() {}),
          ),
        ],
      ),
    );
  }
}

class _HeaderCs extends StatelessWidget {
  const _HeaderCs();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kTeal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: kCardShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2, 8, 16, 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 22),
              ),
              const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                // TODO: ganti dengan foto / logo Customer Service.
                child: Icon(Icons.headset_mic, size: 18, color: kTeal),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Service',
                    style: poppins(
                        size: 16, weight: FontWeight.w700, color: Colors.white),
                  ),
                  Text(
                    'Online',
                    style: poppins(
                        size: 10, weight: FontWeight.w600, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Gelembung extends StatelessWidget {
  final _Pesan pesan;
  const _Gelembung({required this.pesan});

  @override
  Widget build(BuildContext context) {
    final saya = pesan.dariSaya;
    final lebarMax = MediaQuery.of(context).size.width * 0.72;

    return Align(
      alignment: saya ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        constraints: BoxConstraints(maxWidth: lebarMax),
        decoration: BoxDecoration(
          color: saya ? kTeal : Colors.white,
          borderRadius: saya
              ? const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                )
              : BorderRadius.circular(12),
          boxShadow: kCardShadow,
        ),
        child: Text(
          pesan.teks,
          style: poppins(
            size: 12,
            weight: FontWeight.w400,
            color: saya ? Colors.white : kGreyNav,
          ),
        ),
      ),
    );
  }
}

class _KolomKetik extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onKirim;
  final VoidCallback onChanged;

  const _KolomKetik({
    required this.controller,
    required this.onKirim,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final adaTeks = controller.text.trim().isNotEmpty;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 14, 10),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFD9D9D9)),
            boxShadow: kCardShadow,
          ),
          child: Row(
            children: [
              const Icon(Icons.sentiment_satisfied_alt_outlined,
                  size: 24, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: (_) => onChanged(),
                  onSubmitted: (_) => onKirim(),
                  textInputAction: TextInputAction.send,
                  cursorColor: kTeal,
                  style: poppins(size: 14, weight: FontWeight.w400),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'Ketik Pesan.....',
                    hintStyle: poppins(
                      size: 14,
                      weight: FontWeight.w400,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              if (adaTeks)
                GestureDetector(
                  onTap: onKirim,
                  child: const Icon(Icons.send_rounded, size: 24, color: kTeal),
                )
              else ...const [
                Icon(Icons.attach_file, size: 24, color: Color(0xFF9CA3AF)),
                SizedBox(width: 6),
                Icon(Icons.mic_none, size: 24, color: Color(0xFF9CA3AF)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}