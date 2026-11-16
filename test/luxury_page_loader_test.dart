import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velina/features/webview/widgets/luxury_page_loader.dart';

void main() {
  testWidgets('LuxuryPageLoader renders progress bar and logo badge', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LuxuryPageLoader(
            isLoading: true,
            progress: 0.5,
          ),
        ),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    final indicator = tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
    expect(indicator.value, 0.5);
  });

  testWidgets('LuxuryPageLoader respects isLoading=false', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LuxuryPageLoader(
            isLoading: false,
            progress: 1.0,
          ),
        ),
      ),
    );

    final finder = find.descendant(
      of: find.byType(LuxuryPageLoader),
      matching: find.byType(IgnorePointer),
    );
    expect(finder, findsOneWidget);
    final ignorePointer = tester.widget<IgnorePointer>(finder);
    expect(ignorePointer.ignoring, true);
  });
}
