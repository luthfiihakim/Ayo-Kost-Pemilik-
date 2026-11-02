import 'package:flutter/material.dart';
import 'app_style.dart';

/// Pengaturan notifikasi (beda dengan notifikasi.dart yang berisi daftar notifikasi).
class PengaturanNotifikasiPage extends StatefulWidget {
  const PengaturanNotifikasiPage({super.key});

  @override
  State<PengaturanNotifikasiPage> createState() =>
      _PengaturanNotifikasiPageState();
}

class _PengaturanNotifikasiPageState extends State<PengaturanNotifikasiPage> {
  // TODO: simpan ke penyimpanan lokal / backend (mis. shared_preferences).
  bool _bookingBaru = true;
  bool _pembayaran = true;
  bool _pesanChat = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          const AppHeader(title: 'Notifikasi', radius: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 1, bottom: 8),
                  child: Text(
                    'NOTIFIKASI',
                    style: poppins(
                        size: 14, weight: FontWeight.w400, color: kGreyNav),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFCDCBCB)),
                    boxShadow: kCardShadow,
                  ),
                  child: Column(
                    children: [
                      _BarisSwitch(
                        label: 'Booking baru',
                        nilai: _bookingBaru,
                        onChanged: (v) => setState(() => _bookingBaru = v),
                      ),
                      const _Garis(),
                      _BarisSwitch(
                        label: 'Pembayaran diterima',
                        nilai: _pembayaran,
                        onChanged: (v) => setState(() => _pembayaran = v),
                      ),
                      const _Garis(),
                      _BarisSwitch(
                        label: 'Pesan chat',
                        nilai: _pesanChat,
                        onChanged: (v) => setState(() => _pesanChat = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Garis extends StatelessWidget {
  const _Garis();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Divider(height: 1, thickness: 1, color: Color(0x4DC5C5C5)),
    );
  }
}

class _BarisSwitch extends StatelessWidget {
  final String label;
  final bool nilai;
  final ValueChanged<bool> onChanged;

  const _BarisSwitch({
    required this.label,
    required this.nilai,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: poppins(
                    size: 16, weight: FontWeight.w600, color: kTextDark),
              ),
            ),
            Switch(
              value: nilai,
              onChanged: onChanged,
              thumbColor: const WidgetStatePropertyAll(Colors.white),
              trackColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? kTeal
                    : const Color(0xFFD1D5DB),
              ),
              trackOutlineColor:
                  const WidgetStatePropertyAll(Colors.transparent),
            ),
          ],
        ),
      ),
    );
  }
}