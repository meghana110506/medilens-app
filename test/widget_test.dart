import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medilens/core/constants.dart';
import 'package:medilens/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({
    AppConstants.keyNotificationPermissionRequested: true,
  });

  testWidgets('MediLens smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MediLensApp());
    await tester.pump();
    // SetupScreen uses staged Future.delayed timers (~2.3s) before navigation.
    await tester.pump(const Duration(seconds: 3));
  });
}
