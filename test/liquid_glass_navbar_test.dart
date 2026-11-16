import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velina/widgets/velina_liquid_glass_navbar.dart';

void main() {
  testWidgets(
    'VelinaLiquidGlassNavBar renders 4 RTL tabs and updates selection',
    (WidgetTester tester) async {
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
                return VelinaLiquidGlassNavBar(
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

      // Verify all 4 Arabic tabs exist
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('الأقسام'), findsOneWidget);
      expect(find.text('السلة'), findsOneWidget);
      expect(find.text('حسابي'), findsOneWidget);

      // Tap "الأقسام" (index 1)
      await tester.tap(find.text('الأقسام'));
      await tester.pumpAndSettle();
      expect(selectedIndex, 1);

      // Tap "السلة" (index 2)
      await tester.tap(find.text('السلة'));
      await tester.pumpAndSettle();
      expect(selectedIndex, 2);

      // Tap "حسابي" (index 3)
      await tester.tap(find.text('حسابي'));
      await tester.pumpAndSettle();
      expect(selectedIndex, 3);

      // Tap "الرئيسية" (index 0)
      await tester.tap(find.text('الرئيسية'));
      await tester.pumpAndSettle();
      expect(selectedIndex, 0);
    },
  );
}
