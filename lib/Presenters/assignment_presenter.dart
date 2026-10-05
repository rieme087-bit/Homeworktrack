import '../models/assignment_model.dart';

class AssignmentPresenter {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  Future<void> loadAssignments() async {
    final List<Assignment> fetched =
      (await Assignment.fetchAssignments()) as List<Assignment>;
    _assignments
      ..clear()
      ..addAll(fetched);
  }

  Future<void> addAssignment(String title) async {
    await Assignment.addAssignment(title);
    _assignments.add(Assignment(title: title));
  }

  Future<void> toggleCompleted(int index) async {
    await Assignment.updateCompletionStatus(index, _assignments);
    _assignments[index].iscompleted = !_assignments[index].iscompleted;
  }
}