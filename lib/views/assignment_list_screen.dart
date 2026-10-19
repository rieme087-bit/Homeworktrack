import 'package:flutter/material.dart';

import '../models/assignment_model.dart';
import '../presenters/assignment_presenter.dart';
import '../Presenters/course_presenter.dart';
import '../widgets/add_fab.dart';


enum AssignmentStatusFilter { all, incomplete, complete }

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();
  final CoursePresenter _coursePresenter = CoursePresenter();

  String? _selectedCourseFilter;
  AssignmentStatusFilter _selectedStatusFilter =
      AssignmentStatusFilter.all;
  String? _newAssignmentCourse;
  List<String> _courseNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    await _coursePresenter.loadCourses();
    await _presenter.loadAssignments();

    _courseNames = _coursePresenter.courses.map((c) => c.name).toList();
    if (mounted) setState(() => _isLoading = false);
  }


  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';
    _newAssignmentCourse = _courseNames.isNotEmpty ? _courseNames.first : null;

    showDialog(
      context: context,
      builder: (dialogContext) {
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
                onChanged: (value) =>
                    setState(() => _newAssignmentCourse = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
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
                  if (!mounted || !dialogContext.mounted) return;
                  setState(() {});
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeAssignment(Assignment assignment) async {
    final presenter = _presenter as dynamic;

    try {
      await presenter.removeAssignment(assignment);
      return;
    } catch (_) {}

    try {
      await presenter.deleteAssignment(assignment);
      return;
    } catch (_) {}

    try {
      await presenter.delete(assignment);
      return;
    } catch (_) {}

    throw StateError('AssignmentPresenter does not support deleting assignments.');
  }

  Future<void> _confirmDeleteAssignment(Assignment assignment) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete assignment?'),
        content: Text('Delete "${assignment.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;
    await _removeAssignment(assignment);
    if (mounted) setState(() {});
  }

@override
Widget build(BuildContext context) {
  final assignments = _presenter.assignments;
final displayedAssignments = assignments.where((assignment) {
  final matchesCourse = _selectedCourseFilter == null ||
      assignment.courseName == _selectedCourseFilter;
  final matchesStatus = switch (_selectedStatusFilter) {
    AssignmentStatusFilter.all => true,
    AssignmentStatusFilter.incomplete => !assignment.iscompleted,
    AssignmentStatusFilter.complete => assignment.iscompleted,
  };
  return matchesCourse && matchesStatus;
}).toList();

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
    : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Status:'),
                const SizedBox(width: 12),
                DropdownButton<AssignmentStatusFilter>(
                  value: _selectedStatusFilter,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedStatusFilter = value);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: AssignmentStatusFilter.all,
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: AssignmentStatusFilter.incomplete,
                      child: Text('Incomplete'),
                    ),
                    DropdownMenuItem(
                      value: AssignmentStatusFilter.complete,
                      child: Text('Complete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: displayedAssignments.isEmpty
                ? const Center(child: Text('No matching assignments'))
                : ListView.builder(
                    itemCount: displayedAssignments.length,
                    itemBuilder: (context, index) {
                      final assignment = displayedAssignments[index];
                      return CheckboxListTile(
                        title: Text(assignment.title),
                        subtitle: Text('Course: ${assignment.courseName}'),
                        value: assignment.iscompleted,
                        onChanged: (value) async {
                          await _presenter.toggleCompleted(assignment, value);
                          setState(() {});
                        },
                        secondary: IconButton(
                          tooltip: 'Delete assignment',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () =>
                              _confirmDeleteAssignment(assignment),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ), // ListView.builder
floatingActionButton: AddFAB(onPressed: _showAddAssignmentDialog),
); // Scaffold
}
}
