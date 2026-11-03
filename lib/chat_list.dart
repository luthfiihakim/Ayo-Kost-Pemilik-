import 'package:flutter/material.dart';
import 'app_style.dart';
import 'chat_model.dart';
import 'chat_room.dart';
import 'navigasi_utama.dart';

const _abu = Color(0xFFAAAAAA);

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  Future<void> _bukaChat(Percakapan p) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatRoomPage(percakapan: p)),
    );
    // Muat ulang agar pesan terakhir ikut berubah
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final data = daftarPercakapan;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const _ChatHeader(),
          Expanded(
            child: data.isEmpty
                ? Center(
                    child: Text(
                      'Belum ada percakapan',
                      style: poppins(size: 14, color: _abu),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    itemCount: data.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      indent: 23,
                      endIndent: 23,
                      color: Color(0x4DD9D9D9),
                    ),
                    itemBuilder: (context, i) => _BarisChat(
                      percakapan: data[i],
                      onTap: () => _bukaChat(data[i]),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        index: 3,
        onTap: (i) => pindahTab(context, dari: 3, ke: i),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: kTeal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: kCardShadow,
      ),
      child: Container(
        height: 72,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 23),
        child: Text(
          'Chat',
          style: poppins(
            size: 32,
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _BarisChat extends StatelessWidget {
  final Percakapan percakapan;
  final VoidCallback onTap;

  const _BarisChat({required this.percakapan, required this.onTap});

  String get _preview {
    final t = percakapan.terakhir;
    if (t == null) return 'Belum ada pesan';
    final isi = t.voiceNote ? 'Pesan suara' : (t.teks ?? '');
    return t.dariSaya ? 'Anda: $isi' : isi;
  }

  @override
  Widget build(BuildContext context) {
    final waktu = percakapan.terakhir?.waktu ?? '';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: kTealLight,
                shape: BoxShape.circle,
                boxShadow: kCardShadow,
              ),
              child: Text(
                percakapan.inisial,
                style: poppins(
                  size: 22,
                  weight: FontWeight.w700,
                  color: kTealDark,
                ),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          percakapan.nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppins(size: 16, weight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(waktu, style: poppins(size: 13, color: _abu)),
                    ],
                  ),
                  Text(
                    _preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: poppins(
                      size: 14,
                      weight: FontWeight.w400,
                      color: _abu,
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