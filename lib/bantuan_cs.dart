import 'package:flutter/material.dart';
import 'app_style.dart';
import 'hubungi_cs.dart';

class _Faq {
  final String tanya;
  final String jawab;
  const _Faq(this.tanya, this.jawab);
}

// Pertanyaan ketiga di Figma judulnya salah salin ("Bagaimana menolak booking?")
// padahal jawabannya tentang menonaktifkan kost, jadi judulnya saya sesuaikan.
const _daftarFaq = [
  _Faq(
    'Bagaimana cara menarik saldo?',
    'Buka pendapatan, pilih tarik saldo, lalu pilih rekening tujuan.',
  ),
  _Faq(
    'Bagaimana menolak booking?',
    'Buka permintaan Booking dan tekan Tolak pada penyewa terkait.',
  ),
  _Faq(
    'Bagaimana menonaktifkan kost?',
    'Buka Detail Kost lalu tekan Nonaktifkan.',
  ),
];

class BantuanCsPage extends StatefulWidget {
  const BantuanCsPage({super.key});

  @override
  State<BantuanCsPage> createState() => _BantuanCsPageState();
}

class _BantuanCsPageState extends State<BantuanCsPage> {
  final _cari = TextEditingController();

  @override
  void dispose() {
    _cari.dispose();
    super.dispose();
  }

  List<_Faq> get _hasil {
    final kata = _cari.text.trim().toLowerCase();
    if (kata.isEmpty) return _daftarFaq;
    return _daftarFaq
        .where((f) =>
            f.tanya.toLowerCase().contains(kata) ||
            f.jawab.toLowerCase().contains(kata))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasil = _hasil;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kBackground,
        body: Column(
          children: [
            const AppHeader(title: 'Bantuan & CS', radius: 16),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 23, 20, 16),
                children: [
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kBorder),
                      boxShadow: kCardShadow,
                    ),
                    child: TextField(
                      controller: _cari,
                      onChanged: (_) => setState(() {}),
                      cursorColor: kTeal,
                      style: poppins(size: 14, weight: FontWeight.w400),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: 'Cari Pertanyaan...',
                        hintStyle: poppins(
                          size: 14,
                          weight: FontWeight.w400,
                          color: const Color(0xFFC5C5C5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (hasil.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Center(
                        child: Text(
                          'Pertanyaan tidak ditemukan',
                          style: poppins(size: 13, color: kGreyNav),
                        ),
                      ),
                    )
                  else
                    for (final faq in hasil) ...[
                      _KartuFaq(faq: faq),
                      const SizedBox(height: 10),
                    ],
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
                child: AppButton(
                  label: 'Hubungi Layanan Pelanggan',
                  height: 41,
                  fontSize: 15,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HubungiCsPage()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KartuFaq extends StatelessWidget {
  final _Faq faq;
  const _KartuFaq({required this.faq});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFCDCBCB)),
        boxShadow: kCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(faq.tanya, style: poppins(size: 14, weight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(
            faq.jawab,
            style: poppins(size: 12, weight: FontWeight.w400, color: kTextDark),
          ),
        ],
      ),
    );
  }
}