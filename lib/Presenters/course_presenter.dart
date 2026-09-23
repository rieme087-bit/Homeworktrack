import 'package:homework_tracker/models/course_model.dart';


class CoursePresenter {
  final List<Course> _courses = [];

  List<Course> get courses => _courses;

  void addCourse(String name, {String? description}) {
    _courses.add(Course(name: name.trim(), description: description?.trim()));
  }
}