import '../models/course_model.dart';

class CoursePresenter {
  final List<Course> _courses = [];

  List<Course> get courses => _courses;

  Future<void> loadCourses() async {
    final fetched = await Course.fetchCourses();
    _courses
      ..clear()
      ..addAll(fetched);
  }

  Future<void> addCourse(String name, String? description) async {
    final id = await Course.addCourse(name, description);
    if (id != null) {
      _courses.add(Course(id: id, name: name, description: description));
    }
  }

  Future<void> deleteCourse(String id) async {
    await Course.deleteCourse(id);
    _courses.removeWhere((course) => course.id == id);
  }
}