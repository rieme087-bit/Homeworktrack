// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework_tracker/widgets/add_fab.dart';

void main() {
  testWidgets('AddFAB renders and triggers onPressed when tapped', (
    WidgetTester tester,
  ) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton: AddFAB(
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    // Verify icon is present
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the FAB
    await tester.tap(find.byType(AddFAB));
    await tester.pump(); // Allow tap to complete

    // Confirm callback was triggered
    expect(wasPressed, isTrue);
  });
}