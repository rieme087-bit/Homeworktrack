import '../models/assignment_model.dart';

class AssignmentPresenter {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  void addAssignment(String title) {
      _assignments.add(Assignment(title: title.trim()));
    }
  

  void toggleCompleted(int index, bool? value) {
      _assignments[index].iscompleted = value ?? false;   
  }
}