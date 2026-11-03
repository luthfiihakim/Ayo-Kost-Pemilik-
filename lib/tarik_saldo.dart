import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_style.dart';
import 'saldo_model.dart';
import 'saldo_widgets.dart';
import 'bukti_penarikan.dart';
import 'transaksi_gagal.dart';

/// Langkah 2 penarikan: isi jumlah, lihat biaya admin, lalu tarik.
class TarikSaldoPage extends StatefulWidget {
  final Rekening rekening;
  const TarikSaldoPage({super.key, required this.rekening});

  @override
  State<TarikSaldoPage> createState() => _TarikSaldoPageState();
}

class _TarikSaldoPageState extends State<TarikSaldoPage> {
  final _store = SaldoStore.instance;
  final _jumlahC = TextEditingController();
  bool _dicoba = false;
  bool _loading = false;

  @override
  void dispose() {
    _jumlahC.dispose();
    super.dispose();
  }

  int get _jumlah => int.tryParse(_jumlahC.text.replaceAll('.', '')) ?? 0;

  String? get _error {
    if (_jumlahC.text.isEmpty) {
      return _dicoba ? 'Masukkan jumlah penarikan' : null;
    }
    if (_jumlah > _store.saldo) return 'Jumlah melebihi saldo tersedia';
    if (_jumlah < SaldoStore.minPenarikan) {
      return _dicoba
          ? 'Minimal penarikan ${rupiah(SaldoStore.minPenarikan)}'
          : null;
    }
    return null;
  }

  bool get _valid =>
      _jumlah >= SaldoStore.minPenarikan && _jumlah <= _store.saldo;

  Future<void> _tarik() async {
    FocusScope.of(context).unfocus();
    setState(() => _dicoba = true);
    if (!_valid) return;

    setState(() => _loading = true);
    final hasil = await _store.tarik(widget.rekening, _jumlah);
    if (!mounted) return;
    setState(() => _loading = false);

    if (hasil.berhasil) {
      // Sisakan Dashboard + Informasi Saldo, lalu tampilkan bukti
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => BuktiPenarikanPage(penarikan: hasil)),
        (r) => r.settings.name == kRouteSaldo || r.isFirst,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TransaksiGagalPage(penarikan: hasil)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    final adaError = error != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: kBackground,
        body: Column(
          children: [
            const AppHeader(title: 'Tarik Saldo', radius: 28),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Saldo tersedia
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x6DAAAAAA)),
                        boxShadow: kCardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Saldo tersedia',
                              style: poppins(
                                  size: 16,
                                  weight: FontWeight.w600,
                                  color: kTextDark)),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              rpTitik(_store.saldo),
                              style: poppins(
                                size: 24,
                                weight: FontWeight.w800,
                                color: const Color(0xFF075D5D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text('Jumlah penarikan',
                          style: poppins(
                              size: 15,
                              weight: FontWeight.w600,
                              color: const Color(0xFF1C1B1F))),
                    ),
                    const SizedBox(height: 10),
                    // Input jumlah
                    Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: adaError ? Colors.red : Colors.transparent,
                          width: adaError ? 1.5 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _jumlahC,
                        keyboardType: TextInputType.number,
                        inputFormatters: [_RibuanFormatter()],
                        onChanged: (_) => setState(() {}),
                        style: poppins(size: 15, weight: FontWeight.w600),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: 'Min. Rp 15.000',
                          hintStyle: poppins(
                              size: 15,
                              weight: FontWeight.w600,
                              color: const Color(0xFFAAAAAA)),
                          prefixText: 'Rp. ',
                          prefixStyle:
                              poppins(size: 15, weight: FontWeight.w600),
                        ),
                      ),
                    ),
                    if (adaError)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(Icons.error_outline,
                                  color: Colors.red, size: 15),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(error,
                                  style: poppins(
                                      size: 12,
                                      weight: FontWeight.w500,
                                      color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 22),
                    // Biaya admin & diterima
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBFBFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x6DAAAAAA)),
                      ),
                      child: Column(
                        children: [
                          _BarisBiaya(
                              label: 'Biaya admin',
                              nilai: rpTitik(SaldoStore.biayaAdmin)),
                          const Opacity(opacity: 0.6, child: GarisPemisah()),
                          _BarisBiaya(
                            label: 'Diterima',
                            nilai: _valid
                                ? rpTitik(_jumlah - SaldoStore.biayaAdmin)
                                : '-',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
              child: TombolUtama(
                label: 'Tarik Sekarang',
                height: 54,
                loading: _loading,
                onPressed: _tarik,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarisBiaya extends StatelessWidget {
  final String label;
  final String nilai;
  const _BarisBiaya({required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: poppins(size: 14, weight: FontWeight.w500, color: kGreyText)),
          Text(nilai, style: poppins(size: 14, weight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// Menyisipkan titik ribuan saat mengetik: 1500000 -> 1.500.000
class _RibuanFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return const TextEditingValue(text: '');
    if (digits.length > 10) digits = digits.substring(0, 10);
    final teks = angka(int.parse(digits));
    return TextEditingValue(
      text: teks,
      selection: TextSelection.collapsed(offset: teks.length),
    );
  }
}