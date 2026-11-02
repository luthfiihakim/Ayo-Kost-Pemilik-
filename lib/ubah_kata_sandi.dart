import 'package:flutter/material.dart';
import 'app_style.dart';

class UbahKataSandiPage extends StatefulWidget {
  const UbahKataSandiPage({super.key});

  @override
  State<UbahKataSandiPage> createState() => _UbahKataSandiPageState();
}

class _UbahKataSandiPageState extends State<UbahKataSandiPage> {
  final _lama = TextEditingController();
  final _baru = TextEditingController();
  final _konfirmasi = TextEditingController();
  bool _lihatLama = false;
  bool _lihatBaru = false;
  bool _lihatKonfirmasi = false;

  @override
  void dispose() {
    _lama.dispose();
    _baru.dispose();
    _konfirmasi.dispose();
    super.dispose();
  }

  void _pesan(String teks) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(teks)));
  }

  void _simpan() {
    if (_lama.text.isEmpty || _baru.text.isEmpty || _konfirmasi.text.isEmpty) {
      _pesan('Lengkapi semua kolom');
      return;
    }
    if (_baru.text.length < 8) {
      _pesan('Kata sandi baru minimal 8 karakter');
      return;
    }
    if (_baru.text != _konfirmasi.text) {
      _pesan('Konfirmasi kata sandi tidak sama');
      return;
    }
    // TODO: kirim kata sandi lama & baru ke backend di sini.
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Kata sandi berhasil diubah')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kBackground,
        body: Column(
          children: [
            const AppHeader(title: 'Ubah Kata Sandi', radius: 16),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
                      child: Column(
                        children: [
                          _KolomSandi(
                            label: 'Kata sandi lama',
                            hint: 'Masukkan kata sandi lama',
                            controller: _lama,
                            lihat: _lihatLama,
                            onToggle: () =>
                                setState(() => _lihatLama = !_lihatLama),
                          ),
                          const SizedBox(height: 17),
                          _KolomSandi(
                            label: 'Kata sandi baru',
                            hint: 'Minimal 8 karakter',
                            controller: _baru,
                            lihat: _lihatBaru,
                            onToggle: () =>
                                setState(() => _lihatBaru = !_lihatBaru),
                          ),
                          const SizedBox(height: 17),
                          _KolomSandi(
                            label: 'Konfirmasi kata sandi',
                            hint: 'Ulangi kata sandi baru',
                            controller: _konfirmasi,
                            lihat: _lihatKonfirmasi,
                            onToggle: () => setState(
                                () => _lihatKonfirmasi = !_lihatKonfirmasi),
                          ),
                          const Spacer(),
                          const SizedBox(height: 24),
                          AppButton(
                            label: 'Simpan',
                            height: 41,
                            fontSize: 15,
                            onPressed: _simpan,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KolomSandi extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool lihat;
  final VoidCallback onToggle;

  const _KolomSandi({
    required this.label,
    required this.hint,
    required this.controller,
    required this.lihat,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            label,
            style: poppins(size: 14, weight: FontWeight.w600, color: kGreyText),
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.only(left: 14, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBorder),
            boxShadow: kCardShadow,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: !lihat,
                  cursorColor: kTeal,
                  style: poppins(size: 14, weight: FontWeight.w400),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: poppins(
                      size: 14,
                      weight: FontWeight.w400,
                      color: const Color(0xFFC5C5C5),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggle,
                child: Icon(
                  lihat ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 20,
                  color: const Color(0xFFC5C5C5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}