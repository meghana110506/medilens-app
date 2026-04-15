import 'package:flutter_test/flutter_test.dart';
import 'package:medilens/main.dart';

void main() {
  testWidgets('MediLens smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediLensApp());
  });
}
