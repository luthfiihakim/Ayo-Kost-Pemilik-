import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemilik/call_page.dart';
import 'package:pemilik/chat_model.dart';
import 'package:pemilik/chat_room.dart';

void main() {
  testWidgets('ChatRoomPage renders messages and sends text', (tester) async {
    final percakapan = Percakapan(
      nama: 'Budi Santoso',
      pesan: [
        const Pesan(teks: 'Halo pak', dariSaya: false, waktu: '10:00'),
        const Pesan(teks: 'Iya halo', dariSaya: true, waktu: '10:01'),
        Pesan(
          dariSaya: true,
          waktu: '10:02',
          durasiVoice: 5,
          gelombang: List.filled(28, 0.5),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChatRoomPage(percakapan: percakapan),
      ),
    );

    // Verify recipient name and initial
    expect(find.text('Budi Santoso'), findsOneWidget);
    expect(find.text('BS'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);

    // Verify existing messages
    expect(find.text('Halo pak'), findsOneWidget);
    expect(find.text('Iya halo'), findsOneWidget);

    // Test sending text
    final inputField = find.byType(TextField);
    expect(inputField, findsOneWidget);

    await tester.enterText(inputField, 'Apakah kamar masih ada?');
    await tester.pump();

    final sendButton = find.byIcon(Icons.send);
    expect(sendButton, findsOneWidget);

    await tester.tap(sendButton);
    await tester.pump();

    expect(find.text('Apakah kamar masih ada?'), findsOneWidget);
    expect(percakapan.pesan.length, 4);
  });

  testWidgets('ChatRoomPage navigates to CallPage when phone button is clicked',
      (tester) async {
    final percakapan = Percakapan(nama: 'Budi Santoso');

    await tester.pumpWidget(
      MaterialApp(
        home: ChatRoomPage(percakapan: percakapan),
      ),
    );

    final phoneButton = find.byIcon(Icons.phone_outlined);
    expect(phoneButton, findsOneWidget);

    await tester.tap(phoneButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(CallPage), findsOneWidget);
  });

  testWidgets('ChatRoomPage test mic long-press and lock', (tester) async {
    final percakapan = Percakapan(nama: 'Budi Santoso');

    await tester.pumpWidget(
      MaterialApp(
        home: ChatRoomPage(percakapan: percakapan),
      ),
    );

    final micFinder = find.byKey(const ValueKey('tombol-mic'));
    expect(micFinder, findsOneWidget);

    final gesture = await tester.startGesture(tester.getCenter(micFinder));
    await tester.pump(const Duration(milliseconds: 600));

    // Recording should be active
    expect(find.text('0:00'), findsOneWidget);

    // Slide left to lock (> 100px)
    await gesture.moveBy(const Offset(-120, 0));
    await tester.pump(const Duration(milliseconds: 100));

    // Release pointer - should stay locked
    await gesture.up();
    await tester.pump();

    expect(find.text('Merekam...'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);

    // Cancel recording
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Merekam...'), findsNothing);
  });

  testWidgets('ChatRoomPage does not overflow on narrow screens',
      (tester) async {
    tester.view.physicalSize = const Size(320 * 2, 640 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final percakapan = Percakapan(
      nama: 'Budi Santoso',
      pesan: [
        const Pesan(teks: 'Halo', dariSaya: false, waktu: '10:00'),
        Pesan(
          dariSaya: false,
          waktu: '10:01',
          durasiVoice: 3,
          gelombang: List.filled(28, 0.4),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ChatRoomPage(percakapan: percakapan),
      ),
    );
    await tester.pump();

    final micFinder = find.byKey(const ValueKey('tombol-mic'));
    final gesture = await tester.startGesture(tester.getCenter(micFinder));
    await tester.pump(const Duration(milliseconds: 600));

    // No overflow during recording!
    await gesture.up();
    await tester.pump();
  });

  testWidgets('ChatRoomPage opens emoji picker and inserts emoji',
      (tester) async {
    final percakapan = Percakapan(nama: 'Budi Santoso');

    await tester.pumpWidget(
      MaterialApp(
        home: ChatRoomPage(percakapan: percakapan),
      ),
    );

    final emojiButton = find.byIcon(Icons.add_reaction_outlined);
    expect(emojiButton, findsOneWidget);

    await tester.tap(emojiButton);
    await tester.pumpAndSettle();

    expect(find.text('Pilih Emoji'), findsOneWidget);
    await tester.tap(find.text('😊'));
    await tester.pumpAndSettle();

    final inputField = find.byType(TextField);
    final fieldWidget = tester.widget<TextField>(inputField);
    expect(fieldWidget.controller?.text, '😊');
  });

  testWidgets('ChatRoomPage opens attachment sheet and sends attachment',
      (tester) async {
    final percakapan = Percakapan(nama: 'Budi Santoso');

    await tester.pumpWidget(
      MaterialApp(
        home: ChatRoomPage(percakapan: percakapan),
      ),
    );

    final attachButton = find.byIcon(Icons.add_circle_outline);
    expect(attachButton, findsOneWidget);

    await tester.tap(attachButton);
    await tester.pumpAndSettle();

    expect(find.text('Dokumen'), findsOneWidget);
    expect(find.text('Kamera'), findsOneWidget);
    expect(find.text('Galeri'), findsOneWidget);
    expect(find.text('Lokasi'), findsOneWidget);

    await tester.tap(find.text('Galeri'));
    await tester.pumpAndSettle();

    expect(find.text('🖼️ Foto dari galeri'), findsOneWidget);
    expect(percakapan.pesan.length, 1);
  });
}
