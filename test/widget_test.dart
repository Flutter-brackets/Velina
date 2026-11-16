import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velina/core/constants/app_strings.dart';
import 'package:velina/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('VelinaApp launches splash screen smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VelinaApp());

    // Verify typography logo and subtitle
    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.appSubtitle), findsOneWidget);
    expect(find.text(AppStrings.poweredBy), findsOneWidget);

    // Pump past splash timer to settle navigation
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // Verify navigating to Onboarding
    expect(find.text(AppStrings.onboarding1Title), findsOneWidget);
    expect(find.text(AppStrings.next), findsOneWidget);
  });
}
