import 'package:flutter_test/flutter_test.dart';
import 'package:survival_sentinel/main.dart';

void main() {
  testWidgets('App boots into splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const HavenProtocolApp());
    expect(find.text('HAVEN PROTOCOL'), findsOneWidget);
  });
}
