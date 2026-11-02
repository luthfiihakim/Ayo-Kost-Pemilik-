import 'package:flutter/material.dart';
import 'app_style.dart';
import 'profil_model.dart';

const _isianLatar = Color(0xFFF4F7FC);
const _labelAbu = Color(0xFF989898);

/// Mengembalikan [ProfilData] yang sudah diubah lewat Navigator.pop.
class EditProfilPage extends StatefulWidget {
  final ProfilData data;
  const EditProfilPage({super.key, required this.data});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  static const _pilihanGender = ['Laki-laki', 'Perempuan'];

  late final TextEditingController _nama;
  late final TextEditingController _noHp;
  late final TextEditingController _alamat;
  late String _gender;

  @override
  void initState() {
    super.initState();
    _nama = TextEditingController(text: widget.data.nama);
    _noHp = TextEditingController(text: widget.data.noHp);
    _alamat = TextEditingController(text: widget.data.alamat);
    _gender = _pilihanGender.contains(widget.data.jenisKelamin)
        ? widget.data.jenisKelamin
        : _pilihanGender.first;
  }

  @override
  void dispose() {
    _nama.dispose();
    _noHp.dispose();
    _alamat.dispose();
    super.dispose();
  }

  void _pesan(String teks) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(teks)));
  }

  void _simpan() {
    if (_nama.text.trim().isEmpty) {
      _pesan('Nama tidak boleh kosong');
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    // TODO: kirim perubahan ke backend di sini.
    Navigator.pop(
      context,
      widget.data.copyWith(
        nama: _nama.text.trim(),
        jenisKelamin: _gender,
        noHp: _noHp.text.trim(),
        alamat: _alamat.text.trim(),
      ),
    );
    messenger.showSnackBar(const SnackBar(content: Text('Profil diperbarui')));
  }

  void _ubahFoto() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ubah Foto Profil',
                  style: poppins(size: 16, weight: FontWeight.w700)),
              const SizedBox(height: 14),
              _PilihanFoto(
                icon: Icons.photo_camera_outlined,
                label: 'Ambil Foto',
                onTap: () {
                  Navigator.pop(sheetContext);
                  // TODO: image_picker -> ImageSource.camera
                  _pesan('Tambahkan paket image_picker untuk mengambil foto');
                },
              ),
              const SizedBox(height: 10),
              _PilihanFoto(
                icon: Icons.photo_library_outlined,
                label: 'Pilih Foto',
                onTap: () {
                  Navigator.pop(sheetContext);
                  // TODO: image_picker -> ImageSource.gallery
                  _pesan('Tambahkan paket image_picker untuk memilih foto');
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kTeal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(sheetContext),
                  child: Text('Batal',
                      style: poppins(
                          size: 15, weight: FontWeight.w600, color: kTeal)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kBackground,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              SizedBox(
                height: top + 221,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: top + 161,
                      decoration: const BoxDecoration(
                        color: kTeal,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(28)),
                      ),
                    ),
                    Positioned(
                      top: top + 14,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 44,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 87,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () => Navigator.maybePop(context),
                                  icon: const Icon(Icons.arrow_back_ios_new,
                                      color: Colors.white, size: 22),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Edit Profil',
                                textAlign: TextAlign.center,
                                style: poppins(
                                    size: 22,
                                    weight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 87,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 13),
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: _simpan,
                                      child: SizedBox(
                                        width: 74,
                                        height: 44,
                                        child: Center(
                                          child: Text(
                                            'Simpan',
                                            style: poppins(
                                                size: 12,
                                                weight: FontWeight.w600,
                                                color: kTeal),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: top + 96,
                      left: 0,
                      right: 0,
                      child: Center(child: _FotoProfil(onKamera: _ubahFoto)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 11, 13, 24),
                padding: const EdgeInsets.fromLTRB(9, 12, 9, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Etiket('Nama'),
                    _Kotak(child: _isian(_nama)),
                    const SizedBox(height: 11),
                    const _Etiket('Jenis Kelamin'),
                    _Kotak(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _gender,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: poppins(size: 15, weight: FontWeight.w400),
                          items: [
                            for (final g in _pilihanGender)
                              DropdownMenuItem(value: g, child: Text(g)),
                          ],
                          onChanged: (v) =>
                              setState(() => _gender = v ?? _gender),
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    const _Etiket('Email'),
                    _Kotak(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: poppins(
                                  size: 15,
                                  weight: FontWeight.w400,
                                  color: _labelAbu),
                            ),
                          ),
                          const Icon(Icons.lock_outline,
                              size: 18, color: _labelAbu),
                        ],
                      ),
                    ),
                    const SizedBox(height: 11),
                    const _Etiket('No Hp'),
                    _Kotak(child: _isian(_noHp, tipe: TextInputType.phone)),
                    const SizedBox(height: 11),
                    const _Etiket('Alamat Lengkap'),
                    _Kotak(child: _isian(_alamat)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _isian(TextEditingController c, {TextInputType? tipe}) {
    return TextField(
      controller: c,
      keyboardType: tipe,
      cursorColor: kTeal,
      style: poppins(size: 15, weight: FontWeight.w400),
      decoration: const InputDecoration(isCollapsed: true, border: InputBorder.none),
    );
  }
}

class _FotoProfil extends StatelessWidget {
  final VoidCallback onKamera;
  const _FotoProfil({required this.onKamera});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      height: 125,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 59,
              backgroundColor: kTealLight,
              // TODO: ganti dengan foto profil (NetworkImage / FileImage).
              child: Icon(Icons.person, size: 64, color: kTeal),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 5,
            child: GestureDetector(
              onTap: onKamera,
              child: Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: kTeal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_camera_outlined,
                      size: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Etiket extends StatelessWidget {
  final String teks;
  const _Etiket(this.teks);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, bottom: 6),
      child: Text(
        teks,
        style: poppins(size: 16, weight: FontWeight.w600, color: _labelAbu),
      ),
    );
  }
}

class _Kotak extends StatelessWidget {
  final Widget child;
  const _Kotak({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: _isianLatar,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _PilihanFoto extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PilihanFoto(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _isianLatar,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: kTealLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: kTeal, size: 22),
              ),
              const SizedBox(width: 12),
              Text(label, style: poppins(size: 14, weight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}