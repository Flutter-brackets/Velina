import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velina/core/constants/app_strings.dart';
import 'package:velina/core/theme/app_theme.dart';
import 'package:velina/features/onboarding/onboarding_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createWidgetUnderTest({VoidCallback? onFinished}) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: OnboardingScreen(onFinished: onFinished),
    );
  }

  testWidgets('Onboarding 3-page flow verification', (WidgetTester tester) async {
    bool isFinished = false;
    await tester.pumpWidget(createWidgetUnderTest(
      onFinished: () => isFinished = true,
    ));
    await tester.pumpAndSettle();

    // Page 1
    expect(find.text(AppStrings.onboarding1Title), findsOneWidget);
    expect(find.text(AppStrings.onboarding1Subtitle), findsOneWidget);
    expect(find.text(AppStrings.poweredBy), findsOneWidget);
    expect(find.text(AppStrings.next), findsOneWidget);

    // Tap Next -> Page 2
    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.onboarding2Title), findsOneWidget);
    expect(find.text(AppStrings.onboarding2Subtitle), findsOneWidget);

    // Tap Next -> Page 3
    await tester.tap(find.text(AppStrings.next));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.onboarding3Title), findsOneWidget);
    expect(find.text(AppStrings.onboarding3Subtitle), findsOneWidget);
    expect(find.text(AppStrings.startShopping), findsOneWidget);

    // Tap "ابدأ التسوق الآن"
    await tester.tap(find.text(AppStrings.startShopping));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(AppStrings.keyOnboardingCompleted), isTrue);
    expect(isFinished, isTrue);
  });
}
