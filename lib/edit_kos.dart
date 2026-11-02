import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_style.dart';
import 'kos_model.dart';

/// Mengembalikan [Kos] yang sudah diperbarui lewat Navigator.pop,
/// atau null kalau dibatalkan.
class EditKosPage extends StatefulWidget {
  final Kos kos;
  const EditKosPage({super.key, required this.kos});

  @override
  State<EditKosPage> createState() => _EditKosPageState();
}

class _EditKosPageState extends State<EditKosPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaC;
  late final TextEditingController _alamatC;
  late final TextEditingController _hargaC;
  late final TextEditingController _jumlahC;
  late final TextEditingController _fasilitasC;
  late final TextEditingController _deskripsiC;

  @override
  void initState() {
    super.initState();
    final k = widget.kos;
    _namaC = TextEditingController(text: k.nama);
    _alamatC = TextEditingController(text: k.alamat);
    _hargaC = TextEditingController(text: k.harga.toString());
    _jumlahC = TextEditingController(text: k.jumlahKamar.toString());
    _fasilitasC = TextEditingController(text: k.fasilitas.join('\n'));
    _deskripsiC = TextEditingController(text: k.deskripsi);
  }

  @override
  void dispose() {
    _namaC.dispose();
    _alamatC.dispose();
    _hargaC.dispose();
    _jumlahC.dispose();
    _fasilitasC.dispose();
    _deskripsiC.dispose();
    super.dispose();
  }

  void _simpan() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi data yang bertanda merah'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final jumlah = int.parse(_jumlahC.text);
    final tersedia =
        widget.kos.kamarTersedia > jumlah ? jumlah : widget.kos.kamarTersedia;

    // Fasilitas dipisah per baris atau koma
    final fasilitas = _fasilitasC.text
        .split(RegExp(r'[\n,]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    Navigator.pop(
      context,
      widget.kos.copyWith(
        nama: _namaC.text.trim(),
        alamat: _alamatC.text.trim(),
        harga: int.parse(_hargaC.text),
        jumlahKamar: jumlah,
        kamarTersedia: tersedia,
        fasilitas: fasilitas,
        deskripsi: _deskripsiC.text.trim(),
      ),
    );
  }

  // Dekorasi input sesuai Figma: putih, border DBDBDB, radius 14 / 20.
  // Teks error disembunyikan (cukup border merah + snackbar) supaya
  // bayangan kotak tetap rapi.
  InputDecoration _dekorasi(
    String hint, {
    String? prefix,
    String? suffix,
    double radius = 14,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
  }) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: poppins(size: 15, color: const Color(0xFFAAAAAA)),
      prefixText: prefix,
      prefixStyle: poppins(size: 15),
      suffixText: suffix,
      suffixStyle: poppins(size: 15),
      filled: true,
      fillColor: Colors.white,
      contentPadding: padding,
      isDense: true,
      errorStyle: const TextStyle(height: 0, fontSize: 0),
      enabledBorder: border(kBorder),
      focusedBorder: border(kTeal),
      errorBorder: border(Colors.red),
      focusedErrorBorder: border(Colors.red),
    );
  }

  Widget _kotak({required double radius, required Widget child}) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: kCardShadow,
        ),
        child: child,
      );

  Widget _label(String teks) => Padding(
        padding: const EdgeInsets.only(left: 6, bottom: 6),
        child: Text(teks, style: poppins(size: 15, weight: FontWeight.w600)),
      );

  Widget _wajib(
    TextEditingController c,
    String hint, {
    TextInputType? type,
    List<TextInputFormatter>? formatter,
    String? prefix,
    String? suffix,
    TextAlign align = TextAlign.start,
    bool Function(String)? valid,
  }) {
    return _kotak(
      radius: 14,
      child: TextFormField(
        controller: c,
        keyboardType: type,
        inputFormatters: formatter,
        textAlign: align,
        textInputAction: TextInputAction.next,
        style: poppins(size: 15),
        decoration: _dekorasi(hint, prefix: prefix, suffix: suffix),
        validator: (v) {
          final teks = (v ?? '').trim();
          if (teks.isEmpty) return 'wajib';
          if (valid != null && !valid(teks)) return 'tidak valid';
          return null;
        },
      ),
    );
  }

  Widget _areaTeks(TextEditingController c, String hint, int minLines) {
    return _kotak(
      radius: 20,
      child: TextFormField(
        controller: c,
        minLines: minLines,
        maxLines: minLines + 3,
        keyboardType: TextInputType.multiline,
        style: poppins(size: 15),
        decoration: _dekorasi(
          hint,
          radius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: kBackground,
        body: Column(
          children: [
            const AppHeader(title: 'Edit Kos', radius: 28, centerTitle: true),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(11, 8, 11, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Nama kost'),
                      _wajib(_namaC, 'Nama kost'),
                      const SizedBox(height: 10),
                      _label('Alamat lengkap'),
                      _wajib(_alamatC, 'Alamat lengkap'),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 210,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Harga / Bulan'),
                                _wajib(
                                  _hargaC,
                                  '750000',
                                  type: TextInputType.number,
                                  formatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  prefix: 'Rp. ',
                                  suffix: ' / bulan',
                                  valid: (v) => (int.tryParse(v) ?? 0) > 0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            flex: 113,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Jumlah kamar'),
                                _wajib(
                                  _jumlahC,
                                  '20',
                                  type: TextInputType.number,
                                  formatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  align: TextAlign.center,
                                  valid: (v) => (int.tryParse(v) ?? 0) >= 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _label('Fasilitas'),
                      _areaTeks(
                        _fasilitasC,
                        'Ketik fasilitas kos anda disini\n(satu per baris, contoh: AC, Wifi)',
                        3,
                      ),
                      const SizedBox(height: 12),
                      _label('Deskripsi'),
                      _areaTeks(
                        _deskripsiC,
                        'Kost nyaman, 5 menit ke kampus',
                        4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Expanded(
                  flex: 144,
                  child: AppButton(
                    label: 'Batal',
                    filled: false,
                    height: 52,
                    fontSize: 15,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  flex: 154,
                  child: AppButton(
                    label: 'Simpan\nPerubahan',
                    height: 52,
                    fontSize: 15,
                    onPressed: _simpan,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}