// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:homework_tracker/main.dart';

void main() {
  testWidgets('splash screen loads before the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeworkTrackerApp());

    expect(find.text('Loading...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Homework Tracker'), findsOneWidget);
    expect(find.text('Welcome to Homework Tracker!'), findsOneWidget);
  });
}
