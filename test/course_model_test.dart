import 'package:flutter_test/flutter_test.dart';
import 'package:homework_tracker/models/course_model.dart';

void main() {
  test('Course model stores name and optional description', () {
    final course = Course(name: 'History', description: 'World Wars', id: '');
    expect(course.name, 'History');
    expect(course.description, 'World Wars');
  });

  test('Course model handles null description', () {
    final course = Course(name: 'Art', id: '');
    expect(course.description, isNull);
  });
}