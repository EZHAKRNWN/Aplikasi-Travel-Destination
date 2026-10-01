import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_si_a/main.dart';

void main() {
  testWidgets('Travel Destination smoke test: memuat halaman Login', (WidgetTester tester) async {
    // Membangun app dan me-render frame pertama
    await tester.pumpWidget(const MyApp());

    // Memverifikasi bahwa elemen-elemen halaman Login tampil
    expect(find.text('Travel Destination'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('MASUK'), findsOneWidget);
  });
}
