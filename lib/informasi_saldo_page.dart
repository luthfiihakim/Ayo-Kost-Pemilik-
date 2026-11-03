import 'package:flutter/material.dart';
import 'app_style.dart';
import 'saldo_model.dart';
import 'saldo_widgets.dart';
import 'pilih_rekening.dart';

class InformasiSaldoPage extends StatefulWidget {
  /// 0 = Total Pendapatan, 1 = Riwayat Penarikan
  final int tabAwal;
  const InformasiSaldoPage({super.key, this.tabAwal = 0});

  @override
  State<InformasiSaldoPage> createState() => _InformasiSaldoPageState();
}

class _InformasiSaldoPageState extends State<InformasiSaldoPage> {
  final _store = SaldoStore.instance;
  late int _tab; // 0 = Total Pendapatan, 1 = Riwayat Penarikan

  @override
  void initState() {
    super.initState();
    _tab = widget.tabAwal;
  }

  void _tarikSaldo() {
    if (_store.saldo < SaldoStore.minPenarikan) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Saldo belum cukup. Minimal penarikan ${rupiah(SaldoStore.minPenarikan)}'),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PilihRekeningPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: kBgSaldo,
          body: Column(
            children: [
              SizedBox(
                height: yFigma(context, 155),
                child: Stack(
                  children: [
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: HeaderBerwarna(
                          title: 'Informasi Saldo', tinggi: 120),
                    ),
                    Positioned(
                      top: yFigma(context, 69),
                      left: 16,
                      right: 16,
                      height: 86,
                      child: _KartuSaldo(saldo: _store.saldo),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 11, 14, 0),
                child: _TabBar(
                  tab: _tab,
                  onChanged: (i) => setState(() => _tab = i),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(14, 16, 14, 20),
                  child: _tab == 0
                      ? _TabPendapatan(store: _store)
                      : _TabRiwayat(store: _store),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BarTombolBawah(
            child: TombolUtama(label: 'Tarik Saldo', onPressed: _tarikSaldo),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
class _KartuSaldo extends StatelessWidget {
  final int saldo;
  const _KartuSaldo({required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kGarisTipis),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Saldo Tersedia',
              style: poppins(size: 15, weight: FontWeight.w600, color: kTextDark)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              rpTitik(saldo),
              style: poppins(size: 32, weight: FontWeight.w700, color: kTealDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int tab;
  final ValueChanged<int> onChanged;
  const _TabBar({required this.tab, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const label = ['Total Pendapatan', 'Riwayat Penarikan'];
    return Container(
      height: 55,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (var i = 0; i < 2; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == tab ? kTeal : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: i == tab ? kCardShadow : null,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label[i],
                      style: poppins(
                        size: 15,
                        weight: FontWeight.w600,
                        color: i == tab ? const Color(0xFFF5F5F5) : kTextDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1: Total Pendapatan
// ---------------------------------------------------------------------------
class _TabPendapatan extends StatelessWidget {
  final SaldoStore store;
  const _TabPendapatan({required this.store});

  static const _alpha = [0x9E, 0xD3, 0xA5, 0xF4, 0xCC];

  @override
  Widget build(BuildContext context) {
    final data = store.pendapatan6Bulan;
    final maks = data.reduce((a, b) => a > b ? a : b);
    const tinggiMaks = 90.0;
    final transaksi = store.transaksi.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _KartuStat(
                  judul: 'Bulan ini',
                  nilai: rupiah(store.pendapatanBulanIni),
                  keterangan: '+12% dari bulan lalu',
                  warnaKeterangan: kTealDark,
                  beratKeterangan: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KartuStat(
                  judul: 'Total Ditarik',
                  nilai: rupiah(store.totalDitarik),
                  keterangan: '${store.jumlahPenarikan} kali penarikan',
                  warnaKeterangan: kTextDark,
                  beratKeterangan: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text('Pendapatan 6 Bulan Terakhir',
              style: poppins(size: 15, weight: FontWeight.w700)),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 16, 10, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: kCardShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < data.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: tinggiMaks * data[i] / maks,
                          decoration: BoxDecoration(
                            color: i == data.length - 1
                                ? kTeal
                                : Color.fromARGB(
                                    _alpha[i % _alpha.length], 0x95, 0xD2, 0xD2),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          SaldoStore.labelBulan[i],
                          style: poppins(
                              size: 13, weight: FontWeight.w600, color: kTextDark),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text('Transaksi Terbaru',
              style: poppins(size: 15, weight: FontWeight.w700)),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: kCardShadow,
          ),
          child: Column(
            children: [
              for (var i = 0; i < transaksi.length; i++) ...[
                if (i > 0)
                  const Opacity(opacity: 0.3, child: GarisPemisah()),
                _BarisTransaksi(transaksi: transaksi[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _KartuStat extends StatelessWidget {
  final String judul;
  final String nilai;
  final String keterangan;
  final Color warnaKeterangan;
  final FontWeight beratKeterangan;

  const _KartuStat({
    required this.judul,
    required this.nilai,
    required this.keterangan,
    required this.warnaKeterangan,
    required this.beratKeterangan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: kCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(judul,
              style: poppins(size: 13, weight: FontWeight.w500, color: kTextDark)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(nilai, style: poppins(size: 15, weight: FontWeight.w700)),
          ),
          const SizedBox(height: 4),
          Text(keterangan,
              style: poppins(size: 12, weight: beratKeterangan, color: warnaKeterangan)),
        ],
      ),
    );
  }
}

class _BarisTransaksi extends StatelessWidget {
  final Transaksi transaksi;
  const _BarisTransaksi({required this.transaksi});

  @override
  Widget build(BuildContext context) {
    final masuk = transaksi.jumlah >= 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaksi.judul,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: poppins(size: 14, weight: FontWeight.w600)),
                Text(tglPendek(transaksi.tanggal),
                    style: poppins(
                        size: 13, weight: FontWeight.w600, color: kTextDark)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            masuk
                ? '+ ${rpRapat(transaksi.jumlah)}'
                : '- ${rpRapat(transaksi.jumlah.abs())}',
            style: poppins(
              size: 14,
              weight: masuk ? FontWeight.w700 : FontWeight.w600,
              color: masuk ? kTealDark : const Color(0xFFEB221E),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 2: Riwayat Penarikan
// ---------------------------------------------------------------------------
class _TabRiwayat extends StatelessWidget {
  final SaldoStore store;
  const _TabRiwayat({required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text('Riwayat Penarikan',
              style: poppins(size: 16, weight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),
        if (store.riwayat.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text('Belum ada penarikan',
                  style: poppins(size: 14, color: kGreyText)),
            ),
          )
        else
          for (final p in store.riwayat) ...[
            _KartuRiwayat(penarikan: p),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _KartuRiwayat extends StatelessWidget {
  final Penarikan penarikan;
  const _KartuRiwayat({required this.penarikan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: kCardShadow,
      ),
      child: Row(
        children: [
          BankLogo(bank: penarikan.rekening.bank, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Penarikan ke ${penarikan.rekening.bank.singkat}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: poppins(size: 15, weight: FontWeight.w700)),
                Text(tglJam(penarikan.waktu),
                    style: poppins(
                        size: 12, weight: FontWeight.w500, color: kTextDark)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(rpTitik(penarikan.jumlah),
                  style: poppins(size: 14, weight: FontWeight.w700)),
              const SizedBox(height: 4),
              PillStatus(
                label: penarikan.berhasil ? '✓  Berhasil' : 'Gagal',
                background: penarikan.berhasil
                    ? const Color(0x6095D2D2)
                    : const Color(0x33FF0000),
                foreground: penarikan.berhasil ? kTealDark : kMerah,
              ),
            ],
          ),
        ],
      ),
    );
  }
}