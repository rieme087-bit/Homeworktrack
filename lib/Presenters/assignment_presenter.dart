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

  Future<void> addAssignment(String title) async {
    final id = await Assignment.addAssignment(title);
    if (id != null) {
      _assignments.add(Assignment(id: id, title: title));
    }
  }

  Future<void> toggleCompleted(int index, bool? value) async {
    if (value == null || index < 0 || index >= _assignments.length) {
      return;
    }

    final assignment = _assignments[index];
    final id = assignment.id;
    if (id != null) {
      await Assignment.updateCompletionStatus(id, value);
    }
    assignment.iscompleted = value;
  }
}