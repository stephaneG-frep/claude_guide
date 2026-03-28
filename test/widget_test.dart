import 'package:flutter_test/flutter_test.dart';
import 'package:claude_guide/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ClaudeGuideApp());
    expect(find.text('Accueil'), findsWidgets);
  });
}
