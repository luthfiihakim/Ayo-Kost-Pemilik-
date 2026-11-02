import 'package:flutter/material.dart';
import 'login.dart';

class BuatPasswordBaru extends StatefulWidget {
  const BuatPasswordBaru({super.key});

  @override
  State<BuatPasswordBaru> createState() => _BuatPasswordBaruState();
}

class _BuatPasswordBaruState extends State<BuatPasswordBaru> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  
  bool _isPasswordError = false;
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _validasiPassword() {
    FocusScope.of(context).unfocus();
    setState(() {
      if (_passController.text != _confirmPassController.text || _confirmPassController.text.isEmpty) {
        _isPasswordError = true;
      } else {
        _isPasswordError = false;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password berhasil diubah! Silakan login kembali.')),
        );

        // Kembali ke halaman Login dan hapus riwayat tumpukan halaman
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );
      }
    });
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
                    Positioned(
                      top: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0x33FFFFFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.home, color: Colors.white, size: 28),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Buat Password Baru',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'verifikasi',
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Masukkan Password Baru',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passController,
                      obscureText: _obscurePass,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        hintText: 'Masukkan Password Baru',
                        filled: true,
                        fillColor: const Color(0xFFFBFBFB),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePass ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePass = !_obscurePass;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0x6DAAAAAA)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF0F9D9D)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Buat kata sandi kuat dengan minimal 8 karakter,\nhuruf besar, huruf kecil, dan angka',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ulangi Password Baru',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmPassController,
                      obscureText: _obscureConfirmPass,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _validasiPassword(),
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        hintText: 'Ulangi Password Baru',
                        filled: true,
                        fillColor: const Color(0xFFFBFBFB),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPass ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPass = !_obscureConfirmPass;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _isPasswordError ? Colors.red : const Color(0x6DAAAAAA),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _isPasswordError ? Colors.red : const Color(0xFF0F9D9D),
                          ),
                        ),
                      ),
                    ),
                    if (_isPasswordError) ...[
                      const SizedBox(height: 6),
                      const Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Kata sandi belum sama. Ketik ulang\nagar kedua kolom persis sama.',
                            style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _validasiPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F9D9D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Simpan Password',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
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
