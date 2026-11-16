import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velina/features/webview/widgets/custom_bottom_nav.dart';

void main() {
  testWidgets('CustomBottomNav renders 4 tabs, red badge, and language switch', (
    WidgetTester tester,
  ) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return CustomBottomNav(
                selectedIndex: selectedIndex,
                onTabSelected: (i) => setState(() => selectedIndex = i),
                isArabic: true,
                cartCount: 3,
              );
            },
          ),
        ),
      ),
    );

    // Arabic labels
    expect(find.text('الرئيسية'), findsOneWidget);
    expect(find.text('السلة'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('بحث'), findsOneWidget);

    // Cart badge count
    expect(find.text('3'), findsOneWidget);

    // Tap "السلة" (index 1)
    await tester.tap(find.text('السلة'));
    await tester.pumpAndSettle();
    expect(selectedIndex, 1);

    // Tap "بحث" (index 3)
    await tester.tap(find.text('بحث'));
    await tester.pumpAndSettle();
    expect(selectedIndex, 3);
  });

  testWidgets('CustomBottomNav renders English tabs when isArabic is false', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomBottomNav(
            selectedIndex: 0,
            onTabSelected: (_) {},
            isArabic: false,
            cartCount: 0,
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });
}
