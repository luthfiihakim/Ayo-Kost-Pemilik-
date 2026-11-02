import 'dart:async';

import 'package:flutter/material.dart';
import 'app_style.dart';
import 'chat_model.dart';

enum _StatusPanggilan { memanggil, masuk, tersambung }

/// Tampilan telepon (UI saja, belum ada suara sungguhan).
/// [panggilanMasuk] = true untuk tampilan "Panggilan masuk".
class CallPage extends StatefulWidget {
  final String nama;
  final String inisial;
  final bool panggilanMasuk;

  const CallPage({
    super.key,
    required this.nama,
    required this.inisial,
    this.panggilanMasuk = false,
  });

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late _StatusPanggilan _status;
  bool _speaker = false;
  bool _mute = false;
  int _detik = 0;
  Timer? _timerSambung;
  Timer? _timerDurasi;

  @override
  void initState() {
    super.initState();
    if (widget.panggilanMasuk) {
      _status = _StatusPanggilan.masuk;
    } else {
      _status = _StatusPanggilan.memanggil;
      // Simulasi: setelah 3 detik panggilan tersambung
      _timerSambung = Timer(const Duration(seconds: 3), _sambungkan);
    }
  }

  @override
  void dispose() {
    _timerSambung?.cancel();
    _timerDurasi?.cancel();
    super.dispose();
  }

  void _sambungkan() {
    if (!mounted) return;
    setState(() {
      _status = _StatusPanggilan.tersambung;
      _detik = 0;
    });
    _timerDurasi = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _detik++);
    });
  }

  void _akhiri() => Navigator.maybePop(context);

  String get _teksStatus {
    switch (_status) {
      case _StatusPanggilan.memanggil:
        return 'Memanggil...';
      case _StatusPanggilan.masuk:
        return 'Panggilan masuk...';
      case _StatusPanggilan.tersambung:
        return formatDurasi(_detik);
    }
  }

  @override
  Widget build(BuildContext context) {
    final huruf = widget.nama.isEmpty ? '?' : widget.nama[0].toUpperCase();

    return Scaffold(
      backgroundColor: kTeal,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Container(
              width: 135,
              height: 135,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: kTealLight,
                shape: BoxShape.circle,
                boxShadow: kCardShadow,
              ),
              child: Text(
                huruf,
                style: poppins(size: 64, weight: FontWeight.w600, color: kTeal),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.nama,
              textAlign: TextAlign.center,
              style: poppins(
                size: 24,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _teksStatus,
              style: poppins(
                size: 13,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Spacer(flex: 5),
            _tombolBawah(),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _tombolBawah() {
    final masuk = _status == _StatusPanggilan.masuk;

    final tombolSpeaker = _TombolBulat(
      icon: _speaker ? Icons.volume_up : Icons.volume_up_outlined,
      warna: _speaker ? Colors.white : const Color(0xFFD9D9D9),
      warnaIkon: _speaker ? kTeal : Colors.black87,
      onTap: () => setState(() => _speaker = !_speaker),
    );

    final tombolMute = _TombolBulat(
      icon: _mute ? Icons.mic_off : Icons.mic,
      warna: _mute ? Colors.white : const Color(0xFFD9D9D9),
      warnaIkon: _mute ? kTeal : Colors.black87,
      onTap: () => setState(() => _mute = !_mute),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: masuk
          ? [
              // Tolak
              _TombolBulat(
                icon: Icons.close,
                warna: Colors.white,
                warnaIkon: Colors.red,
                onTap: _akhiri,
              ),
              tombolMute,
              // Terima
              _TombolBulat(
                icon: Icons.call,
                warna: const Color(0xFF22C55E),
                warnaIkon: Colors.white,
                onTap: _sambungkan,
              ),
            ]
          : [
              tombolSpeaker,
              tombolMute,
              // Akhiri
              _TombolBulat(
                icon: Icons.call_end,
                warna: const Color(0xFFFF0000),
                warnaIkon: Colors.white,
                onTap: _akhiri,
              ),
            ],
    );
  }
}

class _TombolBulat extends StatelessWidget {
  final IconData icon;
  final Color warna;
  final Color warnaIkon;
  final VoidCallback onTap;

  const _TombolBulat({
    required this.icon,
    required this.warna,
    required this.warnaIkon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: warna,
          shape: BoxShape.circle,
          boxShadow: kCardShadow,
        ),
        child: Icon(icon, color: warnaIkon, size: 30),
      ),
    );
  }
}