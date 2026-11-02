import 'package:flutter_test/flutter_test.dart';
import 'package:pemilik/main.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  });
}
