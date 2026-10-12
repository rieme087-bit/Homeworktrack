import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';
import '../Presenters/course_presenter.dart';
import '../widgets/add_fab.dart';


class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();
  final CoursePresenter _coursePresenter = CoursePresenter();

  String? _selectedCourseFilter;
  String? _newAssignmentCourse;
  List<String> _courseNames = [];
  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    await _presenter.loadAssignments();

    setState(() => _isLoading = false);
    _isLoading = false;
    _courseNames = _coursePresenter.courses.map((c) => c.name).toList();
  }

  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';
    _newAssignmentCourse = _courseNames.isNotEmpty ? _courseNames.first : null;

    showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text('Add Assignment'),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
      decoration: const InputDecoration(
        hintText: 'Enter assignment title',
      ),
      onChanged: (value) => newAssignmentTitle = value,
    ),
    const SizedBox(height: 12),
    DropdownButton<String>(
      value: _newAssignmentCourse,
      items: _courseNames.map((name) {
        return DropdownMenuItem(value: name, child: Text(name));
      }).toList(),
      onChanged: (value) => setState(() => _newAssignmentCourse = value),
    ),
  ],
),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (newAssignmentTitle.trim().isNotEmpty &&
          _newAssignmentCourse != null) {
        await _presenter.addAssignment(
          newAssignmentTitle.trim(),
          _newAssignmentCourse!,
        );
          setState(() {});
           Navigator.pop(context);
         }
        },
          child: const Text('Add'),
        ),
      ],
    );
  },
);
  }

@override
Widget build(BuildContext context) {
  final assignments = _presenter.assignments;
  final displayedAssignments = _selectedCourseFilter == null
      ? assignments
      : assignments
          .where((a) => a.courseName == _selectedCourseFilter)
          .toList();

  return Scaffold(
    appBar: AppBar(
      title: const Text('Assignments'),
      actions: [
        if (_courseNames.isNotEmpty)
          DropdownButton<String>(
            hint: const Text(
              'Filter by course',
              style: TextStyle(color: Colors.white),
            ),
            dropdownColor: Colors.blue[100],
            value: _selectedCourseFilter,
            onChanged: (value) {
              setState(() {
                _selectedCourseFilter = value;
              });
            },
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Courses'),
              ),
              ..._courseNames.map(
                (name) => DropdownMenuItem(value: name, child: Text(name)),
              ),
            ],
          ),
      ],
    ),
    body: _isLoading
    ? const Center(child: CircularProgressIndicator())
    : ListView.builder(
        itemCount: displayedAssignments.length,
        itemBuilder: (context, index) {
          final assignment = displayedAssignments[index];
          return CheckboxListTile(
            title: Text(assignment.title),
            subtitle: Text('Course: ${assignment.courseName}'),
            value: assignment.iscompleted,
            onChanged: (value) async {
              await _presenter.toggleCompleted(index, value);
              setState(() {});
            },
          ); // CheckboxListTile
        },
      ), // ListView.builder
floatingActionButton: AddFAB(onPressed: _showAddAssignmentDialog),
); // Scaffold
}
}