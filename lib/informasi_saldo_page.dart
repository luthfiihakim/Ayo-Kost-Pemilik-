import 'package:flutter/material.dart';
import 'app_style.dart';

// =============================================================================
// 1. HALAMAN UTAMA INFORMASI SALDO
// =============================================================================
class InformasiSaldoPage extends StatefulWidget {
  const InformasiSaldoPage({super.key});

  @override
  State<InformasiSaldoPage> createState() => _InformasiSaldoPageState();
}

class _InformasiSaldoPageState extends State<InformasiSaldoPage> {
  // Saldo saat ini
  final int _totalSaldo = 9500000;

  final List<Map<String, dynamic>> _riwayatTransaksi = [
    {
      'judul': 'Penarikan Saldo',
      'tanggal': '24 Okt 2026, 14:10 WIB',
      'nominal': 1500000,
      'biayaAdmin': 2500,
      'noRef': 'TRX2026102401',
      'status': 'Berhasil',
      'isMasuk': false,
    },
    {
      'judul': 'Pendapatan Sewa Kost',
      'tanggal': '20 Okt 2026, 09:30 WIB',
      'nominal': 500000,
      'biayaAdmin': 0,
      'noRef': 'TRX2026102002',
      'status': 'Berhasil',
      'isMasuk': true,
    },
    {
      'judul': 'Pendapatan Sewa Kost',
      'tanggal': '15 Okt 2026, 11:15 WIB',
      'nominal': 1500000,
      'biayaAdmin': 0,
      'noRef': 'TRX2026101503',
      'status': 'Berhasil',
      'isMasuk': true,
    },
    {
      'judul': 'Penarikan Saldo',
      'tanggal': '10 Okt 2026, 16:45 WIB',
      'nominal': 2000000,
      'biayaAdmin': 2500,
      'noRef': 'TRX2026101004',
      'status': 'Berhasil',
      'isMasuk': false,
    },
  ];

  void _bukaTarikSaldo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TarikSaldoPage(saldoTersedia: _totalSaldo),
      ),
    );
  }

  void _lihatBukti(Map<String, dynamic> item) {
    if (!item['isMasuk']) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BuktiPenarikanPage(
            nominal: item['nominal'] as int,
            biayaAdmin: item['biayaAdmin'] as int,
            noReferensi: item['noRef'] as String,
            tanggalWaktu: item['tanggal'] as String,
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                const SizedBox(height: 16),
                Text(
                  'Detail Transaksi Masuk',
                  style: poppins(
                    size: 16,
                    weight: FontWeight.w700,
                    color: kTealDark,
                  ),
                ),
                const SizedBox(height: 16),
                _detailBaris('Jenis Transaksi', item['judul'] as String),
                _detailBaris('No Referensi', item['noRef'] as String),
                _detailBaris('Tanggal', item['tanggal'] as String),
                _detailBaris('Jumlah Masuk', '+ ${rupiah(item['nominal'] as int)}',
                    warnaValue: kTeal),
                _detailBaris('Status', item['status'] as String,
                    warnaValue: Colors.green),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _detailBaris(String label, String value, {Color? warnaValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: poppins(size: 13, color: kGreyText)),
          Text(
            value,
            style: poppins(
              size: 13,
              weight: FontWeight.w600,
              color: warnaValue ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, 'Informasi Saldo'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Kartu Total Saldo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Saldo',
                          style: poppins(size: 14, color: kGreyNav),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          rupiah(_totalSaldo),
                          style: poppins(
                            size: 28,
                            weight: FontWeight.w700,
                            color: kTeal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kTeal,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _bukaTarikSaldo,
                            child: Text(
                              'Tarik Saldo',
                              style: poppins(
                                size: 15,
                                weight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Riwayat Transaksi',
                    style: poppins(
                      size: 16,
                      weight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final item in _riwayatTransaksi)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _lihatBukti(item),
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: item['isMasuk']
                                            ? kBackground
                                            : const Color(0xFFFFEEEE),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        item['isMasuk']
                                            ? Icons.arrow_downward
                                            : Icons.arrow_upward,
                                        color: item['isMasuk']
                                            ? kTeal
                                            : Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['judul'] as String,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: poppins(
                                              size: 14,
                                              weight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['tanggal'] as String,
                                            style: poppins(
                                              size: 11,
                                              color: kGreyNav,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${item['isMasuk'] ? '+' : '-'} ${rupiah(item['nominal'] as int)}',
                                    style: poppins(
                                      size: 13,
                                      weight: FontWeight.w700,
                                      color: item['isMasuk']
                                          ? kTeal
                                          : Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['status'] as String,
                                    style: poppins(
                                      size: 11,
                                      weight: FontWeight.w500,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 2. HALAMAN FORM TARIK SALDO
// =============================================================================
class TarikSaldoPage extends StatefulWidget {
  final int saldoTersedia;
  const TarikSaldoPage({super.key, this.saldoTersedia = 9500000});

  @override
  State<TarikSaldoPage> createState() => _TarikSaldoPageState();
}

class _TarikSaldoPageState extends State<TarikSaldoPage> {
  final TextEditingController _nominalController =
      TextEditingController(text: '5.000.000');
  static const int _biayaAdmin = 2500;

  @override
  void initState() {
    super.initState();
    _nominalController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  int get _nominalAngka {
    final cleaned =
        _nominalController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  int get _totalDiterima {
    final n = _nominalAngka;
    if (n <= _biayaAdmin) return 0;
    return n - _biayaAdmin;
  }

  void _pilihNominalCepat(int nominal) {
    _nominalController.text = _formatPemisahRibuan(nominal);
  }

  String _formatPemisahRibuan(int nilai) {
    return nilai
        .toString()
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
  }

  void _prosesPenarikan() {
    final nominal = _nominalAngka;
    if (nominal < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimal penarikan saldo adalah Rp 10.000'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (nominal > widget.saldoTersedia) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Jumlah penarikan melebihi saldo tersedia (${rupiah(widget.saldoTersedia)})'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final n = DateTime.now();
    final bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ][n.month - 1];
    final tanggalStr =
        '${n.day} $bulan ${n.year}, ${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')} WIB';
    final noRef = '6875${n.millisecondsSinceEpoch.toString().substring(5)}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuktiPenarikanPage(
          nominal: nominal,
          biayaAdmin: _biayaAdmin,
          noReferensi: noRef,
          tanggalWaktu: tanggalStr,
          rekeningTujuan: 'BRI - 738605391203\nMuhammad Hakim',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, 'Tarik Saldo'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saldo tersedia',
                          style: poppins(size: 13, color: kGreyNav),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rupiah(widget.saldoTersedia),
                          style: poppins(
                            size: 22,
                            weight: FontWeight.w700,
                            color: kTeal,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Info Rekening Tujuan
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kTealLight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.account_balance,
                                  color: kTeal,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Rekening Tujuan',
                                      style: poppins(
                                        size: 11,
                                        color: kGreyText,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'BRI - 738605391203 (M. Hakim)',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: poppins(
                                        size: 13,
                                        weight: FontWeight.w600,
                                        color: kTealDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        Text(
                          'Jumlah penarikan',
                          style: poppins(
                            size: 13,
                            weight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nominalController,
                          keyboardType: TextInputType.number,
                          style: poppins(
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            prefixText: 'Rp  ',
                            prefixStyle: poppins(
                              size: 16,
                              weight: FontWeight.w600,
                              color: kTeal,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF9F9F9),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: kBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: kTeal,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Chips nominal cepat
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _chipNominal(1000000, 'Rp 1 Jt'),
                              const SizedBox(width: 8),
                              _chipNominal(2500000, 'Rp 2,5 Jt'),
                              const SizedBox(width: 8),
                              _chipNominal(5000000, 'Rp 5 Jt'),
                              const SizedBox(width: 8),
                              _chipNominal(widget.saldoTersedia, 'Semua'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 10),
                        _buildRowInfo('Biaya admin', rupiah(_biayaAdmin)),
                        const SizedBox(height: 8),
                        _buildRowInfo(
                          'Diterima',
                          rupiah(_totalDiterima),
                          isBold: true,
                          color: kTeal,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kTeal,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _prosesPenarikan,
                      child: Text(
                        'Tarik Sekarang',
                        style: poppins(
                          size: 15,
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipNominal(int nilai, String label) {
    final aktif = _nominalAngka == nilai;
    return InkWell(
      onTap: () => _pilihNominalCepat(nilai),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: aktif ? kTeal : kBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: aktif ? kTeal : kTealLight,
          ),
        ),
        child: Text(
          label,
          style: poppins(
            size: 12,
            weight: FontWeight.w600,
            color: aktif ? Colors.white : kTealDark,
          ),
        ),
      ),
    );
  }

  Widget _buildRowInfo(
    String label,
    String value, {
    bool isBold = false,
    Color color = Colors.black87,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: poppins(size: 13, color: kGreyText),
        ),
        Text(
          value,
          style: poppins(
            size: 13,
            weight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// 3. HALAMAN BUKTI / STATUS PENARIKAN BERHASIL
// =============================================================================
class BuktiPenarikanPage extends StatelessWidget {
  final int nominal;
  final int biayaAdmin;
  final String noReferensi;
  final String tanggalWaktu;
  final String rekeningTujuan;
  final String status;

  const BuktiPenarikanPage({
    super.key,
    this.nominal = 5000000,
    this.biayaAdmin = 2500,
    this.noReferensi = '687542010263',
    this.tanggalWaktu = '17 Agu 2026, 07:25 WIB',
    this.rekeningTujuan = 'BRI - 738605391203\nMuhammad Hakim',
    this.status = 'Berhasil',
  });

  @override
  Widget build(BuildContext context) {
    final total = nominal > biayaAdmin ? nominal - biayaAdmin : 0;

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, 'Bukti Penarikan'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: kTeal,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Penarikan Berhasil',
                          style: poppins(
                            size: 16,
                            weight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tanggalWaktu,
                          style: poppins(size: 11, color: kGreyNav),
                        ),
                        const Divider(height: 30),
                        _buildDetailRow('No Referensi', noReferensi),
                        _buildDetailRow('Tanggal & Waktu', tanggalWaktu),
                        _buildDetailRow('Jenis Transaksi', 'Penarikan Saldo'),
                        _buildDetailRow('Rekening Tujuan', rekeningTujuan),
                        _buildDetailRow('Jumlah', rupiah(nominal)),
                        _buildDetailRow('Biaya Admin', rupiah(biayaAdmin)),
                        _buildDetailRow('Total', rupiah(total)),
                        _buildDetailRow('Metode', 'Transfer bank'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: poppins(size: 13, color: kGreyText),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB5E4E4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  status,
                                  style: poppins(
                                    size: 12,
                                    weight: FontWeight.w700,
                                    color: kTeal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: Text(
                        'Kembali ke Beranda',
                        style: poppins(
                          size: 15,
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: poppins(size: 13, color: kGreyText),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: poppins(
                size: 13,
                weight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// HELPER: HEADER REUSABLE DENGAN TOMBOL KEMBALI
// =============================================================================
Widget _buildHeader(BuildContext context, String judul) {
  return Container(
    width: double.infinity,
    height: 84,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: const BoxDecoration(
      color: kTeal,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(28),
        bottomRight: Radius.circular(28),
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x3F000000),
          blurRadius: 4,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 8),
        Text(
          judul,
          style: poppins(
            size: 20,
            weight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
