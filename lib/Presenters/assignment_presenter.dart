import '../models/assignment_model.dart';

class AssignmentPresenter {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  Future<void> loadAssignments() async {
    final fetched = await Assignment.fetchAssignments();
    _assignments
      ..clear()
      ..addAll(fetched);
  }

  Future<void> addAssignment(String title, String courseName) async {
  await Assignment.addAssignment(title, courseName);
  _assignments.add(Assignment(title: title, courseName: courseName));
}

  Future<void> toggleCompleted(int index, bool? value) async {
    await Assignment.updateCompletionStatus(index as String, value ?? false);
    _assignments[index].iscompleted = value ?? false;
  }
}