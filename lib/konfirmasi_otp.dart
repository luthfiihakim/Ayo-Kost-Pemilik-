import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'buat_password_baru.dart';

class KonfirmasiOtp extends StatefulWidget {
  const KonfirmasiOtp({super.key});

  @override
  State<KonfirmasiOtp> createState() => _KonfirmasiOtpState();
}

class _KonfirmasiOtpState extends State<KonfirmasiOtp> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    // Otomatis fokus ke kotak pertama dan memunculkan keyboard saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onFieldChanged(String value, int index) {
    // Menangani jika user melakukan paste 4 digit sekaligus
    if (value.length > 1) {
      final pastedCode = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (pastedCode.isNotEmpty) {
        for (int i = 0; i < 4; i++) {
          if (i < pastedCode.length) {
            _controllers[i].text = pastedCode[i];
          }
        }
        if (pastedCode.length >= 4) {
          FocusScope.of(context).unfocus();
        } else {
          _focusNodes[pastedCode.length].requestFocus();
        }
        return;
      }
    }

    // Pindah ke kotak berikutnya jika sudah diisi
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == 3) {
      FocusScope.of(context).unfocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _kirimUlangOtp() {
    // Kosongkan semua kotak OTP
    for (var controller in _controllers) {
      controller.clear();
    }

    // Fokuskan kembali ke kotak pertama dan munculkan keyboard
    _focusNodes[0].requestFocus();

    // Tampilkan notifikasi konfirmasi bahwa kode telah dikirim ulang
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Kode OTP baru telah berhasil dikirim ulang!'),
          ],
        ),
        backgroundColor: Color(0xFF0F9D9D),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _submitOtp() {
    final otpCode = _controllers.map((c) => c.text).join();
    if (otpCode.length < 4) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan 4 digit kode OTP dengan lengkap!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuatPasswordBaru()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: const Color(0xFFE6F8F8),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 260,
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F9D9D),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 4))
                  ],
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Konfirmasi OTP',
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verifikasi',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 60,
                          height: 60,
                          child: KeyboardListener(
                            focusNode: FocusNode(),
                            onKeyEvent: (event) {
                              if (event is KeyDownEvent &&
                                  event.logicalKey == LogicalKeyboardKey.backspace) {
                                if (_controllers[index].text.isEmpty && index > 0) {
                                  _controllers[index - 1].clear();
                                  _focusNodes[index - 1].requestFocus();
                                }
                              }
                            },
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              autofocus: index == 0,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: index == 0 ? 4 : 1, // Memungkinkan paste di kotak pertama
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              onTapOutside: (_) => FocusScope.of(context).unfocus(),
                              onChanged: (value) => _onFieldChanged(value, index),
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: const Color(0xFFFBFBFB),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0x6DAAAAAA)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF0F9D9D), width: 2),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submitOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F9D9D),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Konfirmasi',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum menerima kode? ',
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                        InkWell(
                          onTap: _kirimUlangOtp,
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Text(
                              'Kirim ulang',
                              style: TextStyle(
                                color: Color(0xFF0F9D9D),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
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
