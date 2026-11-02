import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Warna & gaya bersama (bisa dipakai semua halaman)
// ---------------------------------------------------------------------------
const kTeal = Color(0xFF0F9D9D);
const kTealDark = Color(0xFF156D6D);
const kTealLight = Color(0xFFD9F1F1);
const kTealSoft = Color(0xFFDFF5F5); // kotak harga di detail kos
const kBackground = Color(0xFFE6F8F8);
const kPageGrey = Color(0xFFF5F5F5); // background halaman detail kos
const kGreyText = Color(0xFF6B7280);
const kGreyNav = Color(0xFF797979);
const kTextDark = Color(0xFF374151);
const kBorder = Color(0xFFDBDBDB);
const kBannerTeal = Color(0x7595D2D2); // banner "2 Kost Terdaftar"
const kBadgeTeal = Color(0x5E0F9D9D); // badge "Aktif"
const kIconCircle = Color(0x3A0F9D9D); // lingkaran ikon menu

const kCardShadow = [
  BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4)),
];

TextStyle poppins({
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

/// 750000 -> "Rp 750.000"
String rupiah(int nilai) {
  final angka = nilai
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
  return 'Rp $angka';
}

// ---------------------------------------------------------------------------
// Header teal dengan tombol kembali
// radius: Kost Saya 16, Detail 22, Edit 28 (sesuai Figma)
// centerTitle: true untuk judul di tengah (halaman Edit Kos)
// ---------------------------------------------------------------------------
class AppHeader extends StatelessWidget {
  final String title;
  final double radius;
  final bool centerTitle;

  const AppHeader({
    super.key,
    this.title = '',
    this.radius = 18,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kTeal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius)),
        boxShadow: kCardShadow,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 22),
              ),
              if (title.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: centerTitle ? 0 : 8),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                      style: poppins(
                        size: centerTitle ? 22 : 20,
                        weight: FontWeight.w600,
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
                )
              else
                const Spacer(),
              if (centerTitle) const SizedBox(width: 48), // penyeimbang
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Foto kost. Kalau asset belum ada / gagal dimuat, tampil placeholder.
// Kalau width/height tidak diisi, foto mengisi ruang yang tersedia.
// ---------------------------------------------------------------------------
class KosFoto extends StatelessWidget {
  final String? asset;
  final double? width;
  final double? height;
  final double radius;
  final bool shadow;

  const KosFoto({
    super.key,
    this.asset,
    this.width,
    this.height,
    this.radius = 12,
    this.shadow = false,
  });

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: kTealLight,
      alignment: Alignment.center,
      child: const Icon(Icons.apartment, color: kTeal, size: 36),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow ? kCardShadow : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: asset == null
            ? _placeholder()
            : Image.asset(
                asset!,
                width: width,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholder(),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tombol aksi gaya Figma (radius 20, shadow).
// filled = true -> teal; false -> abu muda dengan border.
// ---------------------------------------------------------------------------
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool filled;
  final double height;
  final double fontSize;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = true,
    this.height = 42,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final warnaTeks = filled ? Colors.white : Colors.black;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: filled ? kTeal : kPageGrey,
        borderRadius: BorderRadius.circular(20),
        border: filled ? null : Border.all(color: kBorder),
        boxShadow: kCardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: fontSize + 2, color: warnaTeks),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: poppins(
                        size: fontSize,
                        weight: FontWeight.w600,
                        color: warnaTeks,
                      ).copyWith(height: 1.2),
                    ),
                  ],
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
// Bottom navigation. index = null -> tidak ada tab yang aktif.
// ---------------------------------------------------------------------------
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

class AppBottomNav extends StatelessWidget {
  final int? index;
  final ValueChanged<int> onTap;

  const AppBottomNav({super.key, this.index, required this.onTap});

  static const _items = [
    _NavItem(Icons.receipt_long_outlined, 'Booking'),
    _NavItem(Icons.star_border, 'Ulasan'),
    _NavItem(Icons.home_outlined, 'Beranda'),
    _NavItem(Icons.chat_bubble_outline, 'Chat'),
    _NavItem(Icons.person_outline, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: i == index ? kTealLight : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            i == index
                                ? _items[i].icon
                                : _items[i].icon,
                            size: 24,
                            color: i == index ? kTeal : kGreyNav,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _items[i].label,
                          style: poppins(
                            size: 12,
                            weight: FontWeight.w600,
                            color: i == index ? const Color(0xFF374151) : kGreyNav,
                          ),
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