import 'package:flutter/material.dart';
import 'package:homework_tracker/Presenters/course_presenter.dart';
import 'package:homework_tracker/models/course_model.dart';
import 'package:homework_tracker/widgets/add_fab.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final CoursePresenter presenter = CoursePresenter();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    await presenter.loadCourses();
    setState(() => _isLoading = false);
  }

  void _showAddCourseDialog() {
    String name = '';
    String? description;
    
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter course name',
                ),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter course description (optional)',
                ),
                onChanged: (value) {
                  description = value;
                },
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
                if (name.trim().isNotEmpty) {
                  await presenter.addCourse(name.trim(), description);
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

  Future<void> _confirmDeleteCourse(Course course) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete course?'),
        content: Text(
          'Delete "${course.name}"? Its assignments will be kept.',
        ),
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
    await presenter.deleteCourse(course.id);
    if (mounted) setState(() {});
  }

  @override
Widget build(BuildContext context) {
  final courses = presenter.courses;

  return Scaffold(
    appBar: AppBar(title: const Text('Courses')),
    body:
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course.name),
                  subtitle:
                      course.description != null
                          ? Text(course.description!)
                          : null,
                  trailing: IconButton(
                    tooltip: 'Delete course',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDeleteCourse(course),
                  ),
                ); // ListTile
              },
            ), // ListView.builder
    floatingActionButton: AddFAB(onPressed: _showAddCourseDialog,), // FloatingActionButton
  ); // Scaffold
}
}