import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_style.dart';
import 'chat_model.dart';
import 'call_page.dart';

const _teksTerima = Color(0xFF070000);
const _teksKirim = Color(0xFFFAF8F8);
const _waktuTerima = kGreyText;

/// Jarak geser ke kiri (dalam piksel) agar rekaman terkunci.
const _ambangKunci = 100.0;

class ChatRoomPage extends StatefulWidget {
  final Percakapan percakapan;
  const ChatRoomPage({super.key, required this.percakapan});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _teksC = TextEditingController();
  final _scrollC = ScrollController();

  // Rekaman voice note (simulasi)
  final Stopwatch _sw = Stopwatch();
  Timer? _timerRekam;
  bool _merekam = false;
  bool _terkunci = false; // true = rekaman terkunci, jari boleh dilepas
  double _geser = 0; // 0 sampai -160 (digeser ke kiri)

  Percakapan get _p => widget.percakapan;
  int get _detikRekam => _sw.elapsed.inSeconds;

  @override
  void initState() {
    super.initState();
    // Supaya ikon mic/kirim berganti saat mengetik
    _teksC.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _timerRekam?.cancel();
    _teksC.dispose();
    _scrollC.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------
  // Kirim teks
  // ---------------------------------------------------------------------
  void _kirimTeks() {
    final teks = _teksC.text.trim();
    if (teks.isEmpty) return;
    setState(() {
      _p.pesan.add(Pesan(teks: teks, dariSaya: true, waktu: waktuSekarang()));
      _teksC.clear();
    });
    _gulirKeBawah();
  }

  void _kirimTeksKhusus(String teks) {
    setState(() {
      _p.pesan.add(Pesan(teks: teks, dariSaya: true, waktu: waktuSekarang()));
    });
    _gulirKeBawah();
  }

  void _gulirKeBawah() {
    if (_scrollC.hasClients) {
      _scrollC.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // ---------------------------------------------------------------------
  // Voice note:
  //  - TAHAN mic untuk merekam, LEPAS untuk langsung mengirim.
  //  - Sambil menahan, GESER ke kiri untuk MENGUNCI rekaman. Setelah terkunci
  //    jari boleh dilepas; tombol batal (kiri) dan kirim (kanan) muncul.
  // ---------------------------------------------------------------------
  void _mulaiRekam(LongPressStartDetails _) {
    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();
    _timerRekam?.cancel();
    _sw
      ..reset()
      ..start();
    setState(() {
      _merekam = true;
      _terkunci = false;
      _geser = 0;
    });
    _timerRekam = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (mounted) setState(() {}); // perbarui tampilan timer
    });
  }

  void _geserRekam(LongPressMoveUpdateDetails d) {
    if (!_merekam || _terkunci) return;
    final dx = d.offsetFromOrigin.dx.clamp(-160.0, 0.0).toDouble();
    if (dx <= -_ambangKunci) {
      // Sudah cukup jauh: kunci rekaman
      HapticFeedback.mediumImpact();
      setState(() {
        _terkunci = true;
        _geser = 0;
      });
      return;
    }
    setState(() => _geser = dx);
  }

  // Jari dilepas sebelum terkunci -> kirim langsung
  void _lepasRekam(LongPressEndDetails _) {
    if (!_merekam || _terkunci) return;
    final ms = _sw.elapsedMilliseconds;
    _hentikanRekam();
    if (ms < 800) {
      _tampilPetunjukMic(); // terlalu singkat
      return;
    }
    _kirimVoice(max(1, (ms / 1000).round()));
  }

  // Gestur dibatalkan sistem sebelum terkunci (misal ada panggilan masuk)
  void _gestureBatal() {
    if (_merekam && !_terkunci) _hentikanRekam();
  }

  void _hentikanRekam() {
    _timerRekam?.cancel();
    _sw.stop();
    setState(() {
      _merekam = false;
      _terkunci = false;
      _geser = 0;
    });
  }

  // Tombol batal (kiri) saat rekaman terkunci
  void _batalRekamTerkunci() {
    HapticFeedback.lightImpact();
    _hentikanRekam();
  }

  // Tombol kirim (kanan) saat rekaman terkunci
  void _kirimRekamTerkunci() {
    final ms = _sw.elapsedMilliseconds;
    _hentikanRekam();
    if (ms < 800) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rekaman terlalu singkat'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    _kirimVoice(max(1, (ms / 1000).round()));
  }

  void _kirimVoice(int detik) {
    final acak = Random();
    setState(() {
      _p.pesan.add(
        Pesan(
          dariSaya: true,
          waktu: waktuSekarang(),
          durasiVoice: detik,
          gelombang: List.generate(28, (_) => 0.2 + acak.nextDouble() * 0.8),
        ),
      );
    });
    _gulirKeBawah();
  }

  void _tampilPetunjukMic() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tahan tombol mic untuk merekam'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _tampilPilihanLampiran() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _itemLampiran(
                    icon: Icons.insert_drive_file,
                    label: 'Dokumen',
                    color: Colors.indigo,
                    onTap: () {
                      Navigator.pop(ctx);
                      _kirimTeksKhusus('📄 Dokumen terlampir');
                    },
                  ),
                  _itemLampiran(
                    icon: Icons.camera_alt,
                    label: 'Kamera',
                    color: Colors.pink,
                    onTap: () {
                      Navigator.pop(ctx);
                      _kirimTeksKhusus('📷 Foto dari kamera');
                    },
                  ),
                  _itemLampiran(
                    icon: Icons.photo,
                    label: 'Galeri',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(ctx);
                      _kirimTeksKhusus('🖼️ Foto dari galeri');
                    },
                  ),
                  _itemLampiran(
                    icon: Icons.location_on,
                    label: 'Lokasi',
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(ctx);
                      _kirimTeksKhusus('📍 Lokasi Kos Saya');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemLampiran({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: poppins(size: 12, weight: FontWeight.w500, color: kTextDark),
            ),
          ],
        ),
      ),
    );
  }

  void _tampilPilihanEmoji() {
    final emojis = [
      '😊', '👍', '🙏', '🏠', '🔑', '💰', '📍', '📅',
      '⭐', '🕒', '👋', '🎉', '✅', '❤️', '🤝', '📋',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Pilih Emoji',
                style: poppins(size: 14, weight: FontWeight.w600, color: kTealDark),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [
                  for (final e in emojis)
                    InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        _teksC.text = '${_teksC.text}$e';
                        _teksC.selection = TextSelection.fromPosition(
                          TextPosition(offset: _teksC.text.length),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(e, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _telepon() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallPage(nama: _p.nama, inisial: _p.inisial),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final pesan = _p.pesan;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: kBackground,
        body: Column(
          children: [
            _HeaderRoom(percakapan: _p, onTelepon: _telepon),
            Expanded(
              child: ListView.builder(
                controller: _scrollC,
                reverse: true, // pesan terbaru selalu di bawah
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(11, 16, 11, 12),
                itemCount: pesan.length,
                itemBuilder: (context, i) {
                  final m = pesan[pesan.length - 1 - i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _Bubble(pesan: m),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 4, 15, 12),
                child: _barInput(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Satu bar untuk tiga keadaan: mengetik, menahan mic, dan rekaman terkunci.
  Widget _barInput() {
    final adaTeks = _teksC.text.trim().isNotEmpty;

    return Container(
      constraints: const BoxConstraints(minHeight: 44, maxHeight: 120),
      decoration: BoxDecoration(
        color: _merekam ? null : Colors.white,
        gradient: _merekam
            ? const LinearGradient(colors: [kTeal, Color(0xFFF5F5F5)])
            : null,
        borderRadius: BorderRadius.circular(22),
        boxShadow: _merekam ? null : kCardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_terkunci) ...[
            // Rekaman terkunci: batal di kiri
            _ikon(Icons.delete_outline, _batalRekamTerkunci,
                warna: Colors.white),
            const Icon(Icons.fiber_manual_record, color: Colors.red, size: 12),
            const SizedBox(width: 6),
            Text(
              formatDurasi(_detikRekam),
              style: poppins(
                size: 14,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Merekam...',
                    style: poppins(
                      size: 12,
                      weight: FontWeight.w600,
                      color: kTealDark,
                    ),
                  ),
                ),
              ),
            ),
          ] else if (_merekam) ...[
            // Sedang menahan mic (belum terkunci)
            const SizedBox(width: 10),
            const Icon(Icons.fiber_manual_record, color: Colors.red, size: 12),
            const SizedBox(width: 6),
            Text(
              formatDurasi(_detikRekam),
              style: poppins(
                size: 14,
                weight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Expanded(child: Center(child: _petunjukGeser())),
          ] else ...[
            _ikon(Icons.add_reaction_outlined, _tampilPilihanEmoji),
            Expanded(
              child: TextField(
                controller: _teksC,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _kirimTeks(),
                style: poppins(size: 15, weight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: 'Ketik Pesan.....',
                  hintStyle: poppins(
                    size: 15,
                    weight: FontWeight.w400,
                    color: const Color(0x80000000),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                ),
              ),
            ),
            _ikon(Icons.add_circle_outline, _tampilPilihanLampiran),
          ],
          if (_terkunci)
            // Rekaman terkunci: kirim di kanan
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 4),
              decoration: const BoxDecoration(
                color: Color(0x3D088686),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _kirimRekamTerkunci,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.send, color: kTealDark, size: 20),
              ),
            )
          else if (!_merekam && adaTeks)
            _ikon(Icons.send, _kirimTeks, warna: kTeal)
          else
            _mic(),
        ],
      ),
    );
  }

  Widget _ikon(IconData icon, VoidCallback onTap,
      {Color warna = Colors.black87}) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      icon: Icon(icon, color: warna, size: 24),
    );
  }

  Widget _mic() {
    return GestureDetector(
      key: const ValueKey('tombol-mic'),
      behavior: HitTestBehavior.opaque,
      onTap: _tampilPetunjukMic,
      onLongPressStart: _mulaiRekam,
      onLongPressMoveUpdate: _geserRekam,
      onLongPressEnd: _lepasRekam,
      onLongPressCancel: _gestureBatal,
      child: Transform.translate(
        offset: Offset(_geser, 0), // mic ikut bergeser mengikuti jari
        child: Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.only(right: 2),
          decoration: BoxDecoration(
            color: _merekam ? const Color(0x3D088686) : null,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mic,
            color: _merekam ? kTealDark : Colors.black87,
            size: _merekam ? 26 : 24,
          ),
        ),
      ),
    );
  }

  /// Gembok + panah "<<<<" ke kiri. Panah memudar saat digeser.
  Widget _petunjukGeser() {
    final opasitas =
        (1 - _geser.abs() / _ambangKunci).clamp(0.0, 1.0).toDouble();
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline, size: 16, color: kTealDark),
          const SizedBox(width: 4),
          Opacity(
            opacity: opasitas,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 4; i++)
                  Icon(
                    Icons.chevron_left,
                    size: 16,
                    color: kTealDark.withValues(alpha: (255 - i * 40) / 255),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header: kembali, avatar, nama + status, tombol telepon
// ---------------------------------------------------------------------------
class _HeaderRoom extends StatelessWidget {
  final Percakapan percakapan;
  final VoidCallback onTelepon;

  const _HeaderRoom({required this.percakapan, required this.onTelepon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: kTeal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        boxShadow: kCardShadow,
      ),
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            IconButton(
              tooltip: 'Kembali',
              onPressed: () => Navigator.maybePop(context),
              icon:
                  const Icon(Icons.chevron_left, color: Colors.white, size: 32),
            ),
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: kTealLight,
                shape: BoxShape.circle,
                boxShadow: kCardShadow,
              ),
              child: Text(
                percakapan.inisial,
                style: poppins(
                    size: 17, weight: FontWeight.w700, color: kTealDark),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    percakapan.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: poppins(
                      size: 16,
                      weight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Online',
                    style: poppins(
                      size: 10,
                      weight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Telepon',
              onPressed: onTelepon,
              icon: const Icon(Icons.phone_outlined,
                  color: Colors.white, size: 26),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Gelembung pesan (dengan jam di pojok kanan bawah)
// ---------------------------------------------------------------------------
class _Bubble extends StatelessWidget {
  final Pesan pesan;
  const _Bubble({required this.pesan});

  @override
  Widget build(BuildContext context) {
    final saya = pesan.dariSaya;
    final maxLebar = MediaQuery.of(context).size.width * 0.72;
    final keterangan = pesan.voiceNote
        ? '${formatDurasi(pesan.durasiVoice ?? 0)}  ${pesan.waktu}'
        : pesan.waktu;

    return Align(
      alignment: saya ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxLebar),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 12, 6),
          decoration: BoxDecoration(
            color: saya ? kTeal : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(saya ? 16 : 4),
              bottomRight: Radius.circular(saya ? 4 : 16),
            ),
            boxShadow: kCardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pesan.voiceNote)
                _VoiceBubble(pesan: pesan)
              else
                Text(
                  pesan.teks ?? '',
                  style: poppins(
                    size: 14,
                    weight: FontWeight.w400,
                    color: saya ? _teksKirim : _teksTerima,
                  ),
                ),
              const SizedBox(height: 3),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      keterangan,
                      style: poppins(
                        size: 9,
                        weight: FontWeight.w400,
                        color: saya ? const Color(0xCCFFFFFF) : _waktuTerima,
                      ),
                    ),
                    if (saya) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.done_all,
                        size: 13,
                        color: Color(0xCCFFFFFF),
                      ),
                    ],
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

// ---------------------------------------------------------------------------
// Voice note: tombol play/pause + gelombang. Bagian yang sudah "diputar"
// berwarna gelap.
// ---------------------------------------------------------------------------
class _VoiceBubble extends StatefulWidget {
  final Pesan pesan;
  const _VoiceBubble({required this.pesan});

  @override
  State<_VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<_VoiceBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: max(1, widget.pesan.durasiVoice ?? 1)),
    );
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        _ctrl.reset();
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant _VoiceBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pesan.durasiVoice != widget.pesan.durasiVoice) {
      _ctrl.duration = Duration(seconds: max(1, widget.pesan.durasiVoice ?? 1));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_ctrl.isAnimating) {
      _ctrl.stop();
    } else {
      _ctrl.forward();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final saya = widget.pesan.dariSaya;
    final belumDiputar = saya ? Colors.white : const Color(0xFF9AD6D6);
    const sudahDiputar = kTealDark;
    final batang = widget.pesan.gelombang.isEmpty
        ? List<double>.filled(28, 0.5)
        : widget.pesan.gelombang;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final aktif = (_ctrl.value * batang.length).floor();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _toggle,
              child: SizedBox(
                width: 30,
                height: 30,
                child: Center(
                  child: _ctrl.isAnimating
                      ? Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: saya ? Colors.white : kTeal,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.pause,
                            size: 18,
                            color: saya ? kTeal : Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.play_arrow_outlined,
                          size: 30,
                          color: saya ? Colors.white : kTeal,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var i = 0; i < batang.length; i++)
                      Container(
                        width: 3,
                        height: 6 + batang[i] * 20,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: i < aktif ? sudahDiputar : belumDiputar,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
