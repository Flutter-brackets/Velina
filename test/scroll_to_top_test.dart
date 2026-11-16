import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:velina/core/widgets/scroll_to_top_button.dart';

void main() {
  testWidgets('ScrollToTopButton visibility and tap callback', (
    WidgetTester tester,
  ) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScrollToTopButton(
            visible: true,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.byType(ScrollToTopButton), findsOneWidget);
    await tester.tap(find.byType(ScrollToTopButton));
    expect(tapped, isTrue);
  });
}
