import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velina/core/constants/app_strings.dart';
import 'package:velina/features/webview/widgets/luxury_bottom_nav.dart';

void main() {
  testWidgets('LuxuryBottomNav renders 4 Arabic tabs and triggers callback', (
    WidgetTester tester,
  ) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return LuxuryBottomNav(
                selectedIndex: selectedIndex,
                onTabSelected: (index) {
                  setState(() => selectedIndex = index);
                },
              );
            },
          ),
        ),
      ),
    );

    // Verify all 4 tabs exist
    expect(find.text(AppStrings.navHome), findsOneWidget);
    expect(find.text(AppStrings.navOffers), findsOneWidget);
    expect(find.text(AppStrings.navCart), findsOneWidget);
    expect(find.text(AppStrings.navProfile), findsOneWidget);

    // Tap "العروض والأقسام"
    await tester.tap(find.text(AppStrings.navOffers));
    await tester.pumpAndSettle();
    expect(selectedIndex, 1);

    // Tap "السلة"
    await tester.tap(find.text(AppStrings.navCart));
    await tester.pumpAndSettle();
    expect(selectedIndex, 2);

    // Tap "حسابي"
    await tester.tap(find.text(AppStrings.navProfile));
    await tester.pumpAndSettle();
    expect(selectedIndex, 3);
  });
}
