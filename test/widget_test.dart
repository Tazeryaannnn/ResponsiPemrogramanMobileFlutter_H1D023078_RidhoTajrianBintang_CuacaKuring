import 'package:cuaca_kuring/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Cuaca Kuring app builds', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const CuacaKuringApp());
    expect(find.byType(CuacaKuringApp), findsOneWidget);
  });
}
