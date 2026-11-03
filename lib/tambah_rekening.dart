import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_style.dart';
import 'saldo_model.dart';
import 'saldo_widgets.dart';

/// Form tambah rekening pencairan. Mengembalikan [Rekening] lewat Navigator.pop.
class TambahRekeningPage extends StatefulWidget {
  const TambahRekeningPage({super.key});

  @override
  State<TambahRekeningPage> createState() => _TambahRekeningPageState();
}

class _TambahRekeningPageState extends State<TambahRekeningPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomorC = TextEditingController();
  final _namaC = TextEditingController();

  Bank? _bank;
  bool _dropdownTerbuka = false;
  bool _bankError = false;

  @override
  void dispose() {
    _nomorC.dispose();
    _namaC.dispose();
    super.dispose();
  }

  void _simpan() {
    FocusScope.of(context).unfocus();
    final formOk = _formKey.currentState!.validate();
    setState(() => _bankError = _bank == null);
    if (!formOk || _bank == null) return;

    final baru = Rekening(_bank!, _nomorC.text.trim(), _namaC.text.trim());
    final store = SaldoStore.instance;
    final sudahAda = store.rekening.any(
      (r) => r.bank.singkat == baru.bank.singkat && r.nomor == baru.nomor,
    );
    if (sudahAda) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rekening ini sudah terdaftar')),
      );
      return;
    }

    store.tambahRekening(baru);
    Navigator.pop(context, baru);
  }

  InputDecoration _dekorasi(String hint) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: poppins(size: 12, weight: FontWeight.w400, color: kGarisTipis),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      errorStyle: poppins(size: 10, color: Colors.red),
      enabledBorder: border(kBorder),
      focusedBorder: border(kTeal),
      errorBorder: border(Colors.red),
      focusedErrorBorder: border(Colors.red),
    );
  }

  Widget _label(String teks) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 6),
        child: Text(teks, style: poppins(size: 13, weight: FontWeight.w600)),
      );

  Widget _fieldBank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() => _dropdownTerbuka = !_dropdownTerbuka);
          },
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _bankError ? Colors.red : kBorder),
            ),
            child: Row(
              children: [
                if (_bank != null) ...[
                  BankLogo(bank: _bank!, size: 23),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(_bank!.nama,
                        style: poppins(size: 12, weight: FontWeight.w600)),
                  ),
                ] else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text('Pilih bank',
                          style: poppins(
                              size: 12,
                              weight: FontWeight.w400,
                              color: kGarisTipis)),
                    ),
                  ),
                Icon(
                  _dropdownTerbuka
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: kGreyText,
                ),
              ],
            ),
          ),
        ),
        if (_bankError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text('Pilih bank terlebih dahulu',
                style: poppins(size: 10, color: Colors.red)),
          ),
        if (_dropdownTerbuka)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
              boxShadow: kCardShadow,
            ),
            child: Column(
              children: [
                for (var i = 0; i < daftarBank.length; i++) ...[
                  if (i > 0)
                    const Divider(
                        height: 1, color: Color(0xFFE0E0E0), indent: 8, endIndent: 8),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() {
                      _bank = daftarBank[i];
                      _bankError = false;
                      _dropdownTerbuka = false;
                    }),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      child: Row(
                        children: [
                          BankLogo(bank: daftarBank[i], size: 23),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(daftarBank[i].nama,
                                style: poppins(size: 12, weight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
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
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: HeaderBerwarna(
                          title: 'Rekening Pencairan', tinggi: 126),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          14, yFigma(context, 105), 14, 24),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          boxShadow: kCardShadow,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Bank'),
                              _fieldBank(),
                              const SizedBox(height: 14),
                              _label('Nomor rekening'),
                              TextFormField(
                                controller: _nomorC,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(16),
                                ],
                                style: poppins(size: 12),
                                decoration: _dekorasi('0000 0000 0000'),
                                validator: (v) {
                                  final n = (v ?? '').trim();
                                  if (n.isEmpty) return 'Nomor rekening wajib diisi';
                                  if (n.length < 8) return 'Minimal 8 digit';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                              _label('Nama pemilik rekening'),
                              TextFormField(
                                controller: _namaC,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _simpan(),
                                style: poppins(size: 12),
                                decoration: _dekorasi('Sesuai buku tabungan'),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Nama pemilik wajib diisi'
                                        : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  26, 8, 26, MediaQuery.of(context).padding.bottom + 16),
              child: TombolUtama(
                label: 'Tambah Rekening',
                weight: FontWeight.w600,
                height: 49,
                onPressed: _simpan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}