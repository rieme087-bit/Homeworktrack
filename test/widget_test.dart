import 'package:flutter_test/flutter_test.dart';

import 'package:homework_tracker/main.dart';

void main() {
  testWidgets('app loads the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Homework Tracker'), findsOneWidget);
    expect(find.text('Welcome to Homework Tracker!'), findsOneWidget);
  });
}
