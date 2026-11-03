import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'app_style.dart';
import 'saldo_model.dart';

const kBgSaldo = Color(0xFFD1EFEF);
const kMerah = Color(0xFFAE0A0A);
const kGarisTipis = Color(0xFFC5C5C5);

/// Tinggi area status bar yang dipakai (minimal 24 supaya sama dengan Figma).
double statusTop(BuildContext c) =>
    math.max(MediaQuery.of(c).padding.top, 24);

/// Mengubah koordinat Y di Figma (frame 800 px) ke posisi pada layar.
double yFigma(BuildContext c, double y) => y - 24 + statusTop(c);

/// Kembali ke Beranda (Dashboard) dari halaman mana pun di alur saldo.
void kembaliKeBeranda(BuildContext context) {
  final nav = Navigator.of(context);
  nav.popUntil((r) => r.settings.name == kRouteSaldo);
  nav.maybePop();
}

// ---------------------------------------------------------------------------
// Header berwarna melengkung. [tinggi] = tinggi di Figma (frame 800 px).
// ---------------------------------------------------------------------------
class HeaderBerwarna extends StatelessWidget {
  final String title;
  final double tinggi;
  final Color color;
  final bool tombolKembali;

  const HeaderBerwarna({
    super.key,
    this.title = '',
    this.tinggi = 126,
    this.color = kTeal,
    this.tombolKembali = true,
  });

  @override
  Widget build(BuildContext context) {
    final st = statusTop(context);
    return Container(
      width: double.infinity,
      height: tinggi - 24 + st,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: st - 10, left: 8, right: 16),
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              if (tombolKembali)
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 22),
                )
              else
                const SizedBox(width: 8),
              if (title.isNotEmpty)
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: poppins(
                      size: 20,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ).copyWith(
                      shadows: const [
                        Shadow(
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          color: Color(0x40000000),
                        ),
                      ],
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

// ---------------------------------------------------------------------------
// Logo bank (placeholder berwarna; ganti dengan Image.asset kalau ada logo)
// ---------------------------------------------------------------------------
class BankLogo extends StatelessWidget {
  final Bank bank;
  final double size;
  const BankLogo({super.key, required this.bank, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(bank.warna),
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: FittedBox(
        child: Text(
          bank.singkat,
          style: poppins(size: 10, weight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pill status ("Berhasil" / "Gagal")
// ---------------------------------------------------------------------------
class PillStatus extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final double fontSize;

  const PillStatus({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: poppins(size: fontSize, weight: FontWeight.w600, color: foreground),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tombol utama (teal) atau outline (putih + border teal)
// ---------------------------------------------------------------------------
class TombolUtama extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double fontSize;
  final double radius;
  final bool outlined;
  final bool loading;
  final FontWeight weight;

  const TombolUtama({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 50,
    this.fontSize = 20,
    this.radius = 16,
    this.outlined = false,
    this.loading = false,
    this.weight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: outlined ? Colors.white : kTeal,
        borderRadius: BorderRadius.circular(radius),
        border: outlined ? Border.all(color: kTeal) : null,
        boxShadow: kCardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: loading ? null : onPressed,
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: poppins(
                        size: fontSize,
                        weight: weight,
                        color: outlined ? kTeal : Colors.white,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bilah putih di bawah layar berisi satu tombol
// ---------------------------------------------------------------------------
class BarTombolBawah extends StatelessWidget {
  final Widget child;
  const BarTombolBawah({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: kCardShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Satu baris "label ........ nilai" untuk kartu rincian
// ---------------------------------------------------------------------------
class BarisInfo extends StatelessWidget {
  final String label;
  final String? nilai;
  final Widget? nilaiWidget;
  final Color labelColor;
  final FontWeight labelWeight;
  final FontWeight nilaiWeight;
  final double nilaiSize;

  const BarisInfo({
    super.key,
    required this.label,
    this.nilai,
    this.nilaiWidget,
    this.labelColor = kGreyNav,
    this.labelWeight = FontWeight.w500,
    this.nilaiWeight = FontWeight.w500,
    this.nilaiSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label,
              style: poppins(size: 14, weight: labelWeight, color: labelColor)),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: nilaiWidget ??
                  Text(
                    nilai ?? '',
                    textAlign: TextAlign.right,
                    style: poppins(size: nilaiSize, weight: nilaiWeight),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class GarisPemisah extends StatelessWidget {
  const GarisPemisah({super.key});

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, color: kGarisTipis);
}