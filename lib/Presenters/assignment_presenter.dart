import '../models/assignment_model.dart';

class AssignmentPresenter {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  Object? get completionRatio => null;



  Future<void> loadAssignments() async {
    final fetched = await Assignment.fetchAssignments();
    _assignments
      ..clear()
      ..addAll(fetched);
  }

  Future<void> addAssignment(String title, String courseName) async {
    final id = await Assignment.addAssignment(title, courseName);
    if (id != null) {
      _assignments.add(
        Assignment(id: id, title: title, courseName: courseName),
      );
    }
  }

  Future<void> toggleCompleted(Assignment assignment, bool? value) async {
    final id = assignment.id;
    if (id == null) {
      throw StateError('Cannot update an assignment without an ID.');
    }
    final isCompleted = value ?? false;
    await Assignment.updateCompletionStatus(id, isCompleted);
    assignment.iscompleted = isCompleted;
  }

  Future<void> deleteAssignment(Assignment assignment) async {
    final id = assignment.id;
    if (id == null) {
      throw StateError('Cannot delete an assignment without an ID.');
    }
    await Assignment.deleteAssignment(id);
    _assignments.removeWhere((item) => item.id == assignment.id);
  }

  int get totalAssignments => _assignments.length;

  int get completedAssignments =>
    _assignments.where((a) => a.iscompleted).length;

}

