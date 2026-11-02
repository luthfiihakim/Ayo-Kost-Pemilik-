import 'package:flutter/material.dart';
import 'data_penyewa.dart';
import 'chat_model.dart';
import 'chat_room.dart';

const _teal = Color(0xFF0F9D9D);
const _tealDark = Color(0xFF156D6D);
const _tealLight = Color(0xFFD9F1F1);
const _background = Color(0xFFE6F8F8);
const _greyText = Color(0xFF6B7280);

const _cardShadow = [
  BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4)),
];

TextStyle _poppins({
  required double size,
  FontWeight weight = FontWeight.w500,
  Color color = Colors.black,
}) {
  return TextStyle(
    fontFamily: 'Poppins',
    fontSize: size,
    fontWeight: weight,
    color: color,
  );
}

class DetailPenyewaPage extends StatelessWidget {
  final Penyewa penyewa;

  const DetailPenyewaPage({super.key, required this.penyewa});

  void _chatPenyewa(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomPage(
          percakapan: cariAtauBuatPercakapan(penyewa.nama),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: Column(
        children: [
          const _Header(title: 'Detail Data Penyewa'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              children: [
                _ProfilCard(penyewa: penyewa),
                const SizedBox(height: 16),
                _InfoCard(
                  rows: [
                    _InfoRow('Nomor booking', penyewa.noBooking),
                    _InfoRow('Kost', penyewa.kost),
                    _InfoRow('Mulai', penyewa.mulai),
                    _InfoRow('Periode', penyewa.periode),
                    _InfoRow('Metode bayar', penyewa.metodeBayar),
                    _InfoRow('Total', penyewa.total, tebal: true),
                  ],
                ),
                const SizedBox(height: 16),
                _CatatanCard(catatan: penyewa.catatan),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => _chatPenyewa(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Chat Penyewa',
                style: _poppins(
                  size: 16,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  const _Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _teal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        boxShadow: _cardShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 20, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _poppins(
                    size: 20,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfilCard extends StatelessWidget {
  final Penyewa penyewa;
  const _ProfilCard({required this.penyewa});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _cardShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: _tealLight,
            child: Text(
              penyewa.inisial,
              style: _poppins(
                size: 22,
                weight: FontWeight.w700,
                color: _tealDark,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  penyewa.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _poppins(size: 16, weight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  penyewa.noHp,
                  style: _poppins(size: 13, color: _greyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String nilai;
  final bool tebal;
  const _InfoRow(this.label, this.nilai, {this.tebal = false});
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> rows;
  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _cardShadow,
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: Color(0xFFEDEDED)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(rows[i].label,
                      style: _poppins(size: 13, color: _greyText)),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      rows[i].nilai,
                      textAlign: TextAlign.right,
                      style: _poppins(
                        size: 13,
                        weight: FontWeight.w700,
                        color: rows[i].tebal ? _tealDark : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CatatanCard extends StatelessWidget {
  final String catatan;
  const _CatatanCard({required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Catatan penyewa',
              style: _poppins(size: 13, color: _greyText)),
          const SizedBox(height: 6),
          Text(
            catatan.isEmpty ? '-' : catatan,
            style: _poppins(size: 13, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}