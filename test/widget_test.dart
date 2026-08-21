import 'package:flutter_test/flutter_test.dart';
import 'package:nizam_os/main.dart';
void main() {
  testWidgets('Nizam OS loads', (WidgetTester tester) async {
    await tester.pumpWidget(const NizamApp());
    expect(find.byType(NizamApp), findsOneWidget);
  });
}
