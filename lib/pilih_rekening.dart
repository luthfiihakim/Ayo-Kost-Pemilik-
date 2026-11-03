import 'package:flutter/material.dart';
import 'app_style.dart';
import 'saldo_model.dart';
import 'saldo_widgets.dart';
import 'tambah_rekening.dart';
import 'tarik_saldo.dart';

/// Langkah 1 penarikan: pilih rekening pencairan.
class PilihRekeningPage extends StatelessWidget {
  const PilihRekeningPage({super.key});

  Future<void> _tambah(BuildContext context) async {
    final baru = await Navigator.push<Rekening>(
      context,
      MaterialPageRoute(builder: (_) => const TambahRekeningPage()),
    );
    if (baru != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rekening berhasil ditambahkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = SaldoStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: kBackground,
          body: Column(
            children: [
              const HeaderBerwarna(title: 'Rekening Pencairan', tinggi: 126),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(17, 17, 17, 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        'Pilih rekening pencairan',
                        style: poppins(size: 18, weight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (store.rekening.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            'Belum ada rekening.\nTambahkan rekening terlebih dahulu.',
                            textAlign: TextAlign.center,
                            style: poppins(size: 13, color: kGreyText),
                          ),
                        ),
                      )
                    else
                      for (final r in store.rekening) ...[
                        _KartuRekening(
                          rekening: r,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TarikSaldoPage(rekening: r)),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  26,
                  8,
                  26,
                  MediaQuery.of(context).padding.bottom + 20,
                ),
                child: TombolUtama(
                  label: 'Tambah Rekening',
                  weight: FontWeight.w600,
                  height: 50,
                  onPressed: () => _tambah(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KartuRekening extends StatelessWidget {
  final Rekening rekening;
  final VoidCallback onTap;

  const _KartuRekening({required this.rekening, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder),
        boxShadow: kCardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rekening.bank.namaLengkap,
                        style: poppins(
                            size: 14, weight: FontWeight.w400, color: kGreyText),
                      ),
                      Text(
                        rekening.nomor,
                        style: poppins(
                            size: 20, weight: FontWeight.w800, color: kTextDark),
                      ),
                      Text(
                        'a.n. ${rekening.nama}',
                        style: poppins(
                            size: 14, weight: FontWeight.w400, color: kGreyText),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: kGreyText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}